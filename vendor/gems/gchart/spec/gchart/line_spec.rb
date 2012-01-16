require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Line do
  it "renders the correct chart type" do
    GChart::Line.new.render_chart_type.should == "lc"
  end
end
