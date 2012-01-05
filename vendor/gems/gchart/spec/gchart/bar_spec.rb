require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Bar do
  before(:each) do
    @chart = GChart::Bar.new
  end
  
  it "is ungrouped by default" do
    @chart.grouped.should == false
    @chart.should_not be_grouped
  end
  
  it "is horizontal by default" do
    @chart.orientation.should == :horizontal
    @chart.should be_horizontal
    @chart.should_not be_vertical
  end
  
  it "renders the correct chart type" do
    GChart::Bar.new.render_chart_type.should == "bhs"
    GChart::Bar.new(:grouped => true).render_chart_type.should == "bhg"
    GChart::Bar.new(:orientation => :vertical).render_chart_type.should == "bvs"
  end
end

describe GChart::Bar, "#orientation" do
  before(:each) { @chart = GChart::Bar.new }
  
  it "complains if orientation is invalid" do
    lambda { @chart.orientation = :monkey }.should raise_error(ArgumentError)
  end
end

describe GChart::Bar, "#thickness" do
  before(:each) { @chart = GChart::Bar.new }
  
  it "can be specified" do
    @chart.thickness = 10
    @chart.thickness.should == 10
  end
  
  it "complains about negative numbers" do
    lambda { @chart.thickness = -1 }.should raise_error(ArgumentError)
  end
end

describe GChart::Bar, "#spacing" do
  before(:each) { @chart = GChart::Bar.new }
  
  it "can be specified" do
    @chart.spacing = 2
    @chart.spacing.should == 2
  end
  
  it "complains about negative numbers" do
    lambda { @chart.spacing = -1 }.should raise_error(ArgumentError)
  end
end

describe GChart::Bar, "#query_params" do
  before(:each) { @chart = GChart::Bar.new }
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should =~ /b(h|v)(g|s)/
  end
  
  it "contains the chart's bar height" do
    @chart.thickness = 10
    @chart.query_params.keys.include?("chbh").should be_true
    @chart.query_params["chbh"].should == "10"
    @chart.spacing = 2
    @chart.query_params.keys.include?("chbh").should be_true
    @chart.query_params["chbh"].should == "10,2"
  end
  
  it "it does not contain a bar height without a thickness" do
    @chart.spacing = 2
    @chart.query_params.keys.include?("chbh").should be_false
  end
end