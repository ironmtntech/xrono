module AdminBaseHelper
  # This method returns a string for the table row class based on a work unit's
  # hours type. It uses cycle to candy-stripe the table for readability.
  def row_class(options={})
    classes = []
    classes.push(options[:hours_type].downcase) if options[:hours_type]

    classes.push("future") if options[:scheduled_at] > Time.current

    classes = classes.join(' ')

    cycle("#{classes} even","#{classes} odd")
  end
end
