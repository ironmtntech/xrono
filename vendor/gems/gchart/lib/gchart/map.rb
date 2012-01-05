module GChart
  class Map < GChart::Base
    AREAS = %w[africa asia europe middle_east south_america usa world]
    attr_accessor :area
    attr_accessor :area_codes
    attr_accessor :background
    
    def initialize(*args, &block)
      super(*args, &block)
      # Set some sane defaults so that the only requirement is data
      @area = 'world' #default
      @background = 'dfdfff' #make it look like water
      @colors = ['ffffff','f8fcf8','006c00']
      #Set the maximum size for maps (this is a better default because
      # it is also the proper aspect ratio)
      @width = '440'
      @height = '220'
    end
    
    # Map data can be in the form {"VA'=>5,'NY'=>1} or [['VA',5],['NY',1]]
    # Raises +ArgumentError+ if data does not fit these forms.
    def data=(data)
      if data.is_a?(Array) && data.any?{ |pair| pair.size != 2 }
        raise ArgumentError, "Data array must contain [area],[value] pairs"
      end
      # 'unzip' the data into separate arrays
      area_data, values = data.to_a.transpose

      # Reject malformed area codes
      if area_data.any?{ |code| code !~ /^\w\w$/}
        raise ArgumentError, "Area data must have exactly two characters" 
      end
      @area_codes = area_data.join.upcase
      super(values)
    end
    
    def render_chart_type #:nodoc:
      "t"
    end
    
    def area=(area)
      raise ArgumentError unless AREAS.include? area
      @area = area
    end
    
    # overrides GChart::Base#query_params
    def query_params(params={}) #:nodoc:
      params["chtm"] = area unless area.empty?
      params["chld"] = area_codes if area_codes
      params["chf"] = "bg,s,#{@background}" if @background
      super(params)
    end
    
    # overrides GChart::Base#render_data
    def render_data(params)
      super(params)
      # Maps require at least one data point. Add a "missing value".
      # It may be better to refactor the base class.
      params["chd"] << '__' if params["chd"] =~ /e:$/
    end
    
    def render_title(params) #:nodoc:
      nil #N/A for map
    end 
    
    def render_legend(params) #:nodoc:
      nil #N/A for map
    end
    
  end
end
