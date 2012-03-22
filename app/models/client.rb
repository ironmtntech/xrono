class Client < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  has_many :projects
  has_many :tickets, :through => :projects
  has_many :comments, :as => :commentable
  has_many :file_attachments
  has_many :contacts
  has_one  :site_settings
  has_one :data_vault, :as => :data_vaultable

  validates_presence_of   :name, :status
  validates_uniqueness_of :name, :allow_nil => false

  after_create :create_data_vault

  scope :sort_by_name, order('name ASC')
  scope :active, where(:status => '10')
  scope :suspended, where(:status => '20')
  scope :inactive, where(:status => '30')
  scope :for_user, lambda{|user|
   joins("INNER JOIN projects p ON p.client_id=clients.id").joins("INNER JOIN roles r ON r.authorizable_type='Project' AND r.authorizable_id=p.id").joins("INNER JOIN roles_users ru ON ru.role_id = r.id").where("ru.user_id = ?", user.id).select("distinct clients.*")
  }

  def tickets
    Ticket.for_client(self)
  end

  def work_units
    WorkUnit.for_client(self)
  end

  def hours
    work_units.sum(:effective_hours)
  end

  def uninvoiced_hours
    WorkUnit.for_client(self).not_invoiced.sum(:effective_hours)
  end

  def hours_this_month
    WorkUnit.for_client(self).scheduled_between(Time.zone.now.beginning_of_month, Time.zone.now.end_of_month).sum(:effective_hours)
  end

  def hours_this_week
    WorkUnit.for_client(self).scheduled_between(Time.zone.now.beginning_of_week, Time.zone.now.end_of_week).sum(:effective_hours)
  end

  def to_s
    if status == "Active"
      name
    else
      "#{name} (#{status})"
    end
  end

  def status
    Client.statuses[attributes["status"]]
  end

  def status=(val)
    write_attribute(:status, Client.statuses.invert[val])
  end

  def allows_access?(user)
    projects.any? {|p| p.accepts_roles_by?(user)} || user.admin?
  end

  def files_and_comments
    ary = Array.new
    ary << comments
    ary << file_attachments
    ary.flatten.sort_by {|x| x.created_at}
  end

  class << self
    def statuses
      {
        "10" => "Active",
        "20" => "Suspended",
        "30" => "Inactive",
      }
    end

    def for(projects_or_tickets_or_work_units)
      projects_or_tickets_or_work_units.collect{ |resource| resource.client }.uniq
    end

=begin
    def for_user(user)
      select {|c| c.allows_access?(user) }
    end
=end
  end

  private
  def create_data_vault
    self.data_vault = DataVault.create(:data_vaultable => self)
  end
end
