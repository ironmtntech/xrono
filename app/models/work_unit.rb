class WorkUnit < ActiveRecord::Base
  include GuidReferenced
  extend WorkUnit::Finders
  acts_as_commentable

  has_many :comments, :as => :commentable
  belongs_to :ticket
  belongs_to :user

  validates_presence_of :ticket_id, :user_id, :description, :hours, :scheduled_at, :effective_hours, :hours_type
  validates_numericality_of :hours, :greater_than => -1
  before_validation :set_effective_hours!
  after_validation :validate_client_status
  after_create :send_email!


  def validate_client_status
    if client && client.status == "Inactive"
      self.errors.add(:base, "Cannot create work units on inactive clients.")
    end
  end

  def internal?
    SiteSettings.first.try(:client) == client
  end

  def external?
    !internal?
  end

  def send_email!
    WorkUnitNotifierWorker.perform_async(id, email_list) if email_list.any?
  end

  def email_list
   Contact.for_client(self.client).receives_email.pluck(:email_address)
  end

  def client
    ticket.try(:client)
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
    if new_record?
      I18n.t(:new_work_unit)
    else
      description[0..80]
    end
  end

  def allows_access?(user)
    user.has_role?(:admin) || project.accepts_roles_by?(user)
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
