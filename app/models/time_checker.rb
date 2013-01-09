class TimeChecker

  def initialize
    check_time_of_users
  end

  def check_time_of_users
    User.unlocked.all.each do |user|
       if user.developer? && user.hours_entered_for_day(Date.today) < 8
         user.notify!
       end
    end
  end

end
