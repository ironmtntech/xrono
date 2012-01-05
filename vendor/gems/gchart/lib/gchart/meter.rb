module GChart
  class Meter < GChart::Base
    attr_accessor :label
    
    def render_chart_type #:nodoc:
      "gom"
    end
    
    # The data for a meter is a single data point expressed as a percent
    def render_data(params)
      value = data.is_a?(Array) ? data.flatten.first : data
      params["chd"] = "t:#{value.to_f}"
    end
    
    def label=(string)
      return if string.nil?
      if (string.is_a?(Array) && string.size > 1) or string.include?("|")
        raise ArgumentError, "Meter can only have one label"
      end
      @label = string.to_s
    end
    
    # Commandeer render_legend to render the label
    def render_legend(params)
      self.label = legend if self.label.nil? # Can use legend instead of label
      params["chl"] = label if label
    end
  end
end
