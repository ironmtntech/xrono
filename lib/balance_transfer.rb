require 'active_support/all'
class BalanceTransfer
  attr_accessor :date, :users, :distribution_manager

  def initialize(options = {})
    @distribution_manager   = options.fetch(:distribution_manager) { DistributionManager.new }
    @users                  = options.fetch(:users) { User.all }
    @date                   = options.fetch(:date) { 1.day.ago }
    Plutus::Account.find_by_name('MAIN_ACCOUNT')  || Plutus::Asset.create(name: 'MAIN_ACCOUNT')
  end

  def run!
    @users.each do |user|
      check_daily_time(user)
      ten_day_assessment(user)
      award_pto(user)
      handle_expected_hours(user)
    end
  end

  def check_daily_time(user)
    # daily time must be put in before 11:59pm current day.
    # daily time put in must = 8 hours.
    # time not put in each day && >= 8:
    # do not receive $10 per diem
    # $25 demerrit fee assessed
    if user.hours_entered_for_day(@date) < 8
      issue_demerit(user)
    else
      award_per_diem(user)
    end
    add_time_to_offset(user)
  end

  def ten_day_assessment(user)
    # sliding window of 10 days:
    # if 70+ external hours are billed: +1 Remote work day (RWD)
    if user.external_hours(10) > 70
      award_remote_day(user)
    end
  end

  def award_per_diem(user)
    # per diem bonus is incremented + $10
    @distribution_manager.issue_per_diem_to_user(user, 10) unless user.per_diem_account.credited_today?
  end

  def add_time_to_offset(user)
    if user.offset_account.balance == 0
      @time = user.current_offset
    else
      if user.hours_entered_for_day(Time.now) > 8
        @time = user.hours_entered_for_day(Time.now) - 8
      end
    end
    @distribution_manager.issue_time_to_offset user, @time
  end
 
  def business_days_between(date1, date2)
    business_days = 0
    date = date2
    while date > date1
      business_days = business_days + 1 unless date.saturday? or date.sunday?
      date = date - 1.day
    end
    business_days
  end

  def handle_expected_hours(user)
    # Doesn't include todays business day in the count
    previous_business_hours = business_days_between(Date.new(2013, 1,1), Date.today) * 8

    if (1..5).include?(Date.today.wday)
      @distribution_manager.issue_hours_for_expected_hours user, 8
    end
  end

  def award_pto(user)
    # for every 40 hours over offset +1 PTO
    if user.offset_account.balance > 40
      until user.offset_account.balance < 40
        @distribution_manager.deduct_time_from_offset user, 40
        @distribution_manager.issue_pto_to_user user, 1
      end
    end
  end

  def award_remote_day(user)
    @distribution_manager.issue_remote_day_to_user(user, 1) unless user.remote_day_available?
  end

  def issue_demerit(user)
    @distribution_manager.issue_demerit_fee_to_user(user, 25) unless user.demerit_account.credited_today?
  end

  # show total per diem bonus earned
  # PDB (Per diem bonus) will be in the state of qualified or non-qualified.
  # qualified if offset > -1
  # non-qualified if offset < 0
  # suggest making PDB balance field green or red showing qualifying state.

end
