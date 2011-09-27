class Project < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  acts_as_authorization_object

  belongs_to :client
  has_many :tickets
  has_many :comments, :as => :commentable
  has_many :file_attachments

  validates_presence_of :name
  validates_presence_of :client_id
  validates_uniqueness_of :name, :scope => :client_id

  scope :sort_by_name, order('name ASC')
  scope :for_client,    lambda {|client|    where :client_id => client.id }
  scope :for_client_id, lambda {|client_id| where :client_id => client_id }

  scope :for_user, lambda{|user|
    joins("INNER JOIN roles        r ON r.authorizable_type='#{model_name}' AND r.authorizable_id=projects.id")
   .joins("INNER JOIN roles_users ru ON ru.role_id = r.id")
   .joins("INNER JOIN users        u ON ru.user_id = u.id")
   .where("ru.user_id = #{user.id}")
  }

  scope :for_user_and_role, lambda{|user, role|
    joins("INNER JOIN roles        r ON r.authorizable_type='#{model_name}' AND r.authorizable_id=projects.id")
   .joins("INNER JOIN roles_users ru ON ru.role_id = r.id")
   .joins("INNER JOIN users        u ON ru.user_id = u.id")
   .where("ru.user_id = #{user.id} AND r.name = '#{role}'")
  }

  def uninvoiced_hours
    WorkUnit.for_project(self).not_invoiced.sum(:effective_hours)
  end

  def hours
    WorkUnit.for_project(self).sum(:effective_hours)
  end

  def work_units
    WorkUnit.for_project(self)
  end

  def to_s
    name
  end

  def allows_access?(user)
    accepts_roles_by?(user) || user.admin?
  end

  def files_and_comments
    ary = Array.new
    ary << comments
    ary << file_attachments
    ary.flatten.sort_by {|x| x.created_at}
  end

end
