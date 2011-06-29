class WorkUnit < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  has_many :comments, :as => :commentable
  belongs_to :ticket
  belongs_to :user
  validates_presence_of :ticket_id, :user_id, :description, :hours, :scheduled_at, :effective_hours, :hours_type
  validates_numericality_of :hours, :greater_than => -1

  scope :scheduled_between, lambda{|start_time, end_time| where('scheduled_at BETWEEN ? AND ?', start_time, end_time) }
  scope :unpaid, lambda{ where('paid IS NULL or paid = ""') }
  scope :not_invoiced, lambda{ where('invoiced IS NULL OR invoiced = ""') }
  scope :for_client, lambda{|client| joins({:ticket => {:project => [:client]}}).where("clients.id = ?", client.id) }
  scope :for_project, lambda{|project| joins({:ticket => [:project]}).where("projects.id = ?", project.id)}
  scope :for_ticket, lambda {|ticket| where('ticket_id = ?', ticket.id) }
  scope :for_user, lambda{|user| where('user_id = ?', user.id)}
  scope :sort_by_scheduled_at, order('scheduled_at DESC')
  scope :pto, where('hours_type = "PTO"')
  scope :cto, where('hours_type = "CTO"')
  scope :overtime, where('hours_type = "Overtime"')
  scope :normal, where('hours_type = "Normal"')
  before_validation :set_effective_hours!
  after_validation :validate_client_status
  after_save :send_email!

  def validate_client_status
    if client && client.status == "Inactive"
      self.errors.add(:base, "Cannot create work units on inactive clients.")
    end
  end

  def send_email!
    begin
      Notifier.work_unit_notification(self, email_list).deliver if email_list.length > 0
    rescue Exception => e
      logger.warn("At #{Time.now} couldn't deliver notification email for Work Unit: #{ self.id }\n\nHere's the issue: #{e.message}")
    end
  end

  def email_list
    Contact.for_client(self.client).receives_email.map(&:email_address)
  end

  def client
    (ticket && ticket.client) ? ticket.project.client : nil
  end

  def project
    ticket.project
  end

  def unpaid?
    paid.blank?
  end

  def paid?
    !unpaid?
  end

  def invoiced?
    !not_invoiced?
  end

  def not_invoiced?
    invoiced.blank?
  end

  def to_s
    description
  end

  def allows_access?(user)
    project.accepts_roles_by?(user) || user.has_role?(:admin)
  end

  def overtime_multiplier
    if ticket && project && project.overtime_multiplier
      project.overtime_multiplier
    elsif client && client.overtime_multiplier
      client.overtime_multiplier
    elsif SiteSettings.first && SiteSettings.first.overtime_multiplier
      SiteSettings.first.overtime_multiplier
    else
      BigDecimal.new("1.5")
    end
  end

  def set_effective_hours!
    if hours
      if hours_type == "Overtime"
        self.effective_hours = hours * overtime_multiplier
      else
        self.effective_hours = hours
      end
    end
  end

  def overtime?
    hours_type == "Overtime"
  end
end
