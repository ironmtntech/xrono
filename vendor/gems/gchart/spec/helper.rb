$LOAD_PATH.unshift(File.expand_path("#{File.dirname(__FILE__)}/../lib"))

require "spec"
require "gchart"

module GChart
  class Base
    public :query_params
    public :render_chart_type, :render_data
  end
end
