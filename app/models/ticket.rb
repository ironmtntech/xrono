class Ticket < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  belongs_to :project
  has_many :work_units
  has_many :file_attachments

  validates_presence_of :project_id
  validates_presence_of :name

  scope :for_client,     lambda{|client|     joins({:project => [:client]}).where("clients.id = ?", client.id) }
  scope :for_project,    lambda{|project|    where('project_id = ?', project.id) }
  scope :for_project_id, lambda{|project_id| where :project_id => project_id }

  scope :sort_by_name, order('name ASC')

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

  def files_and_comments
    ary = Array.new
    ary << comments
    ary << file_attachments
    ary.flatten.sort_by {|x| x.created_at}
  end

end
