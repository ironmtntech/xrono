require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Sparkline do
  it "renders the correct chart type" do
    GChart::Sparkline.new.render_chart_type.should == "ls"
  end
  
  it "defaults to 60x20" do
    GChart::Sparkline.new.size.should == "60x20"
  end
end

