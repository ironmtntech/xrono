class Project < ActiveRecord::Base
  include GuidReferenced
  acts_as_commentable
  acts_as_authorization_object

  github_concern :repo => :git_repo_name

  belongs_to :client
  has_many :tickets
  has_many :comments, :as => :commentable
  has_many :file_attachments
  has_one :data_vault, :as => :data_vaultable

  validates_presence_of :name
  validates_presence_of :client_id
  validates_uniqueness_of :name, :scope => :client_id

  after_create :create_data_vault

  scope :sort_by_name, order('name ASC')
  scope :for_client,    lambda {|client|    where :client_id => client.id }
  scope :for_client_id, lambda {|client_id| where :client_id => client_id }
  scope :incomplete, where("completed = ?", false)
  scope :complete, where("completed = ?", true)
  scope :with_git_repos, where("git_repo_url IS NOT NULL")

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

  def log_fnord_user(user)
    log_fnord_event(_type: '_set_name', name: user.email, skip_user_logging: true)
    log_fnord_event(_type: '_set_picture', url: user.gravatar_url, skip_user_logging: true)
  end

  def log_fnord_event options
    uuid = UUID.generate
    redis = Redis.new
    event = options.to_json

    redis.set("fnordmetric-event-#{uuid}", event)
    redis.expire("fnordmetric-event-#{uuid}", 60)
    redis.lpush("fnordmetric-queue", uuid)
  end

  def github_concern_callback git_push
    uuid = UUID.generate
    redis = Redis.new
    options = {_type: 'git_push', repo: git_repo_name, branch: "#{git_repo_name}:#{git_push.payload["ref"].gsub("refs/heads/", "")}"}
    if git_push.user
      user = git_push.user
      options["_session"] = user.id.to_s
      log_fnord_user(user) unless options.delete(:skip_user_logging)
    end

    event = options.to_json

    redis.set("fnordmetric-event-#{uuid}", event)
    redis.expire("fnordmetric-event-#{uuid}", 60)
    redis.lpush("fnordmetric-queue", uuid)
  end
  private
  def create_data_vault
    self.data_vault = DataVault.create(:data_vaultable => self)
  end
end
