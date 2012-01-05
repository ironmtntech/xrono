require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::XYLine do
  it "renders the correct chart type" do
    GChart::XYLine.new.render_chart_type.should == "lxy"
  end
end
