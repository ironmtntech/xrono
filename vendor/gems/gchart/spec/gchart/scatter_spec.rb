require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Scatter do
  it "renders the correct chart type" do
    GChart::Scatter.new.render_chart_type.should == "s"
  end
end
