class ShortDay < ActiveRecord::Base

  def within_year(year)
    date.to_s.include?(year)
  end

end
