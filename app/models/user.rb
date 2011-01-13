class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :rememberable, :trackable, :validatable, :lockable
  include Gravtastic
  gravtastic
  is_gravtastic!
  acts_as_authorization_subject :association_name => :roles

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
                  :first_name, :last_name, :middle_initial

  validates_presence_of :first_name, :last_name
  validates_length_of :middle_initial, :is => 1

  has_many :work_units

  # Scopes
  scope :with_unpaid_work_units, joins(:work_units).where(' work_units.paid IS NULL OR work_units.paid = "" ').group('users.id')
  scope :unlocked, where('locked_at IS NULL')
  scope :sort_by_name, order('first_name ASC')

  # Return the initials of the User
  def initials
    "#{first_name[0]}#{middle_initial}#{last_name[0]}".upcase
  end

  def work_units_for_day(time)
    work_units.scheduled_between(time.beginning_of_day, time.end_of_day)
  end

  def clients_for_day(time)
    work_units_for_day(time).map{|x| x.client}.uniq
  end

  def work_units_for_week(time)
    work_units.scheduled_between(time.beginning_of_week, time.end_of_week)
  end

  def unpaid_work_units
    work_units.unpaid
  end

  def to_s
    "#{first_name.capitalize} #{middle_initial.capitalize} #{last_name.capitalize}"
  end

  def admin?
    has_role?(:admin)
  end

  def locked
    locked_at?
  end

  def pto_hours_left(date)
    raise "Date must be a date object" unless date.is_a?(Date)
    time = date.to_time_in_current_zone
    SiteSettings.first.total_yearly_pto_per_user - work_units.pto.scheduled_between(time.beginning_of_year, time.end_of_year).sum(:hours)
  end
end
