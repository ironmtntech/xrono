class Ticket < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  acts_as_audited :only => [:state]
  belongs_to :project
  has_many :work_units
  has_many :file_attachments

  validates_presence_of :project_id
  validates_presence_of :name
  validates_presence_of :estimated_hours

  scope :for_client,     lambda{|client|     joins({:project => [:client]}).where("clients.id = ?", client.id) }
  scope :for_project,    lambda{|project|    where(:project_id => project.id) }
  scope :for_project_id, lambda{|project_id| where :project_id => project_id }
  scope :sort_by_name,   order('name ASC')
  scope :for_state, lambda { |state| where(:state => state) }

  scope :for_user, lambda{|user|
    joins("INNER JOIN projects     p ON p.id=tickets.project_id")
   .joins("INNER JOIN roles        r ON r.authorizable_type='Project' AND r.authorizable_id=p.id")
   .joins("INNER JOIN roles_users ru ON ru.role_id = r.id")
   .where("ru.user_id = #{user.id}")
  }

  scope :for_user_and_role, lambda{|user, role|
    joins("INNER JOIN projects     p ON p.id=tickets.project_id")
   .joins("INNER JOIN roles        r ON r.authorizable_type='Project' AND r.authorizable_id=p.id")
   .joins("INNER JOIN roles_users ru ON ru.role_id = r.id")
   .where("ru.user_id = #{user.id} AND r.name = '#{role}'")
  }

  state_machine :state, :initial => :fridge do
    after_transition do |ticket|
      ticket.send_email!
    end

    state :fridge do
      def advance_state!
        move_to_development!
      end
    end

    state :development do
      def advance_state!
        move_to_peer_review!
      end
    end

    state :peer_review do
      def advance_state!
        move_to_user_acceptance!
      end

      def reverse_state!
        move_to_development!
      end
    end

    state :user_acceptance do
      def advance_state!
        move_to_archived!
      end
      
      def reverse_state!
        move_to_development!
      end
    end

    state :archived do
    end

    event :move_to_development do
      transition [:fridge, :peer_review, :user_acceptance] => :development
    end

    event :move_to_peer_review do
      transition :development => :peer_review
    end

    event :move_to_user_acceptance do
      transition :peer_review => :user_acceptance
    end

    event :move_to_archived do
      transition :user_acceptance => :archived
    end
  end

  def states
    Ticket.state_machine.states.keys if Ticket.state_machine
  end

  ################### ADDING EMAIL FUNCTIONALITY #######################
  def send_email!
    begin
      Notifier.ticket_state_change(self, email_list).deliver if email_list.length > 0
    rescue Exception => e
      logger.warn("At #{Time.now} couldn't deliver notification email for state change on ticket: #{ self.id }\n\nHere's the issue: #{e.message}")
    end
  end

  def email_list
    #list = Contact.for_client(self.client).receives_email.map(&:email_address)
    self.project.users.map(&:email)
  end
  ######################################################################

  def self.for_user(user)
    select {|t| t.allows_access?(user) }
  end

  def client
    project.client
  end

  def to_s
    name
  end

  def hours
    work_units.sum(:effective_hours)
  end

  def unpaid_hours
    work_units.unpaid.sum(:effective_hours)
  end

  def uninvoiced_hours
    work_units.not_invoiced.sum(:effective_hours)
  end

  def percentage_complete
    ((self.hours / self.estimated_hours)).to_f.round(2) * 100 rescue "N/A"
  end

  def long_name
    "Ticket: [#{id}] - #{project.name} - #{name} ticket for #{client.name}"
  end

  def allows_access?(user)
    project.accepts_roles_by?(user) || user.admin?
  end
#### Comment out to look at bug in ticket show page
  def files_and_comments
    [self.file_attachments, self.comments]
  end
end
