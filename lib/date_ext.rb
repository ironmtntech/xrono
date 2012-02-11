class Date

  def prev_working_day
    _day = self - 1
    determine_working_day :prev_working_day, _day
  end

  def next_working_day
    _day = self + 1
    determine_working_day :next_working_day, _day
  end

  private

  def determine_working_day method, _day
    if [6,7].include? _day.cwday
      _day.send(method)
    else
      _day
    end
  end

end
