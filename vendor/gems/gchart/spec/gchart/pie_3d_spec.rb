require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Pie3D do
  it "renders the correct chart type" do
    GChart::Pie3D.new.render_chart_type.should == "p3"
  end
end
