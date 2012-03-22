class Ticket < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  belongs_to :project
  has_many :work_units
  has_many :file_attachments

  #github_concern :class_method => :for_repo_and_branch

  validates_presence_of :project_id
  validates_presence_of :name

  scope :for_client,     lambda{|client|     joins({:project => [:client]}).where("clients.id = ?", client.id) }
  scope :for_project,    lambda{|project|    where(:project_id => project.id) }
  scope :for_projects,   lambda{|projects|   where(:project_id => projects.map(&:id)) }
  scope :for_project_id, lambda{|project_id| where :project_id => project_id }
  scope :sort_by_name,   order('name ASC')
  scope :for_state, lambda { |state| where(:state => state) }
  scope :incomplete, :conditions => ["completed = ?", false]
  scope :complete, :conditions => ["completed = ?", true]

  scope :for_user, lambda{|user|
    joins("INNER JOIN projects p ON p.id=tickets.project_id").joins("INNER JOIN roles r ON r.authorizable_type='Project' AND r.authorizable_id=p.id").joins("INNER JOIN roles_users ru ON ru.role_id = r.id").where("ru.user_id = ?", user.id)
  }

  scope :for_user_and_role, lambda{|user, role|
    joins("INNER JOIN projects p ON p.id=tickets.project_id").joins("INNER JOIN roles r ON r.authorizable_type='Project' AND r.authorizable_id=p.id").joins("INNER JOIN roles_users ru ON ru.role_id = r.id").where("ru.user_id = #{user.id} AND r.name = '#{role}'")
  }

  scope :for_repo_and_branch, lambda{|repo,branch|
    joins("INNER JOIN projects p ON p.id=tickets.project_id").where("p.git_repo_name = '#{repo}' and tickets.git_branch = '#{branch}'")
  }

  scope :for_repo_url_and_branch, lambda{|repo,branch|
    joins("INNER JOIN projects p ON p.id=tickets.project_id").where("p.git_repo_url = '#{repo}' and tickets.git_branch = '#{branch}'")
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

  def percentage_complete
    begin
      percent = (((self.hours / self.estimated_hours)).to_f * 100.00).round(2)
      [percent, 100].min
    rescue
      0
    end
  end

  def remaining_hours
    if self.estimated_hours and self.estimated_hours > self.hours
      self.estimated_hours - self.hours
    else
      0
    end
  end

  def long_name
    "Ticket: [#{id}] - #{project.name} - #{name} ticket for #{client.name}"
  end

  def allows_access?(user)
    project.accepts_roles_by?(user) || user.admin?
  end
#### Comment out to look at bug in ticket show page
  def files_and_comments
    [comments, file_attachments].flatten.sort_by {|x| x.created_at}
  end
end
