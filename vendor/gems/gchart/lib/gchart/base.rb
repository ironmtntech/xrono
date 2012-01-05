require "open-uri"
require "uri"

module GChart
  class Base
    # Array of chart data. See subclasses for specific usage.
    attr_accessor :data

    # Hash of additional HTTP query params.
    attr_accessor :extras

    # Chart title.
    attr_accessor :title

    # Array of rrggbb colors, one per data set.
    attr_accessor :colors

    # Array of legend text, one per data set.
    attr_accessor :legend

    # Array of axis ranges, in order [x,y,r,t]
    attr_accessor :axis

    # Max data value for quantization.
    attr_accessor :max

    # Chart width, in pixels.
    attr_reader :width

    # Chart height, in pixels.
    attr_reader :height

    def initialize(options={}, &block)
      @data = []
      @extras = {}
      @width = 300
      @height = 200

      options.each { |k, v| send("#{k}=", v) }
      yield(self) if block_given?
    end

    # Sets the chart's width, in pixels. Raises +ArgumentError+
    # if +width+ is less than 1 or greater than 1,000.
    def width=(width)
      if width.nil? || width < 1 || width > 1_000
        raise ArgumentError, "Invalid width: #{width.inspect}"
      end

      @width = width
    end

    # Sets the chart's height, in pixels. Raises +ArgumentError+
    # if +height+ is less than 1 or greater than 1,000.
    def height=(height)
      if height.nil? || height < 1 || height > 1_000
        raise ArgumentError, "Invalid height: #{height.inspect}"
      end

      @height = height
    end

    # Returns the chart's size as "WIDTHxHEIGHT".
    def size
      "#{width}x#{height}"
    end

    # Sets the chart's size as "WIDTHxHEIGHT". Raises +ArgumentError+
    # if +width+ * +height+ is greater than 300,000 pixels.
    def size=(size)
      self.width, self.height = size.split("x").collect { |n| Integer(n) }

      if (width * height) > 300_000
        raise ArgumentError, "Invalid size: #{size.inspect} yields a graph with more than 300,000 pixels"
      end
    end

    # Returns the chart's URL.
    def to_url
      query = query_params.collect { |k, v| "#{k}=#{URI.escape(v)}" }.join("&")
      "#{GChart::URL}?#{query}"
    end

    # Returns the chart's generated PNG as a blob.
    def fetch
      open(to_url) { |io| io.read }
    end

    # Writes the chart's generated PNG to a file. If +io_or_file+ quacks like an IO,
    # calls +write+ on it instead.
    def write(io_or_file="chart.png")
      return io_or_file.write(fetch) if io_or_file.respond_to?(:write)
      open(io_or_file, "w+") { |io| io.write(fetch) }
    end

    protected
    def query_params(raw_params={}) #:nodoc:
      params = raw_params.merge("cht" => render_chart_type, "chs" => size)

      render_data(params)
      render_title(params)
      render_colors(params)
      render_legend(params)
      render_axis(params)

      params.merge(extras)
    end

    def render_chart_type #:nodoc:
      raise NotImplementedError, "override in subclasses"
    end

    def render_data(params) #:nodoc:
      raw = data && data.first.is_a?(Array) ? data : [data]
      max = self.max || raw.collect { |s| s.max }.max

      sets = raw.collect do |set|
        set.collect { |n| GChart.encode(:extended, n, max) }.join
      end

      params["chd"] = "e:#{sets.join(",")}"
    end

    def render_title(params) #:nodoc:
      params["chtt"] = title.tr("\n ", "|+") if title
    end

    def render_axis(params) #:nodoc:
      return unless axis
      params["chxt"] = %w(x y r t)[0..axis.length-1].join(",")
      #require 'ruby-debug';debugger;true
      params["chxr"] = axis.select{|a| a[0].is_a?(Integer)}.map{|a| [axis.index(a), *a].join(",") }.join("|")
      params["chxl"] = axis.select{|a| a[0].is_a?(String)}.map{|a| ["#{axis.index(a)}:", *a].join("|") }.join("|")
    end

    def render_colors(params) #:nodoc:
      params["chco"] = colors.join(",") if colors
    end

    def render_legend(params) #:nodoc:
      params["chdl"] = legend.join("|") if legend
    end
  end
end
