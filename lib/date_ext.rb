class Date

  def prev_working_day
    _prev_day = self - 1
    if [6,7].include? _prev_day.cwday
      _prev_day.prev_working_day
    else
      _prev_day
    end
  end

  def next_working_day
    _next_day = self + 1
    if [6,7].include? _next_day.cwday
      _next_day.next_working_day
    else
      _next_day
    end
  end

end