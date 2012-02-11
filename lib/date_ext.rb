class Date

  def prev_working_day
    determine_working_day :prev_working_day, (self - 1)
  end

  def next_working_day
    determine_working_day :next_working_day, (self + 1)
  end

  private

  def determine_working_day method, _day
    [6,7].include?(_day.cwday) ? _day.send(method) : _day
  end
end
