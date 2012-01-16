require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Venn do
  it "renders the correct chart type" do
    GChart::Venn.new.render_chart_type.should == "v"
  end
end
