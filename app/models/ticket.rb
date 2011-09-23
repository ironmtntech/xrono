class Ticket < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  belongs_to :project
  has_many :work_units
  has_many :file_attachments

  validates_presence_of :project_id
  validates_presence_of :name

  scope :for_client, lambda{ |client| joins({:project => [:client]}).where("clients.id = ?", client.id) }
  scope :for_project, lambda { |project| where('project_id = ?', project.id) }
  scope :for_state, lambda { |state| where('state = ?', state) }
  scope :sort_by_name, order('name ASC')

  state_machine :state, :initial => :fridge do
    state :fridge do
    end

    state :development do
    end

    state :peer_review do
    end

    state :user_acceptance do
    end

    state :archived do
    end

    event :move_to_development do
      transition :fridge => :development
      transition :peer_review => :development
      transition :user_acceptance => :development
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

  
  def initialize(args = nil)
    super args
  end

  def fridge
  end

  def in_development
  end

  def peer_review
  end

  def user_acceptance
  end
  
  def archive
  end

  def states
    Ticket.state_machine.states.keys if Ticket.state_machine
  end

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

  def long_name
    "Ticket: [#{id}] - #{project.name} - #{name} ticket for #{client.name}"
  end

  def allows_access?(user)
    project.accepts_roles_by?(user) || user.admin?
  end

end
