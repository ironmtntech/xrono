module GChart
  class Pie < GChart::Base
    # A single array of chart data. Raises +ArgumentError+
    # if more than one data set is provided.
    def data=(data)
      if data.is_a?(Array) and data.first.is_a?(Array) and data.size > 1
        raise ArgumentError, "Pie charts only have one data set" 
      end
      
      super(data)
    end
    
    def render_chart_type #:nodoc:
      "p"
    end
    
    def render_legend(params) #:nodoc:
      params["chl"] = legend.join("|") if legend
    end
  end
end
