module GChart
  class Sparkline < GChart::Base
    # Sparklines are essentially the same as line charts, but without
    # axis lines. Because they are often placed within text, the default
    # size should be smaller.
    def initialize(*args, &block)
      super(*args, &block)
      @width = "60"
      @height = "20"
    end
    def render_chart_type #:nodoc:
      "ls"
    end
  end
end
