require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Map do
  before(:each) { @chart = GChart::Map.new }

  it "initializes to a default area of 'world'" do
    @chart.area.should == 'world'  
  end
  
  it "defaults to maximum size of 440x220" do
    @chart.size.should == '440x220'
  end
  
  it "renders the correct chart type" do
    @chart.render_chart_type.should == "t"
  end
end

describe GChart::Map, "#query_params" do
  before(:each) { @chart = GChart::Map.new }
  
  it "contains the chart's type" do
    @chart.query_params["cht"].should == "t"
  end
  
  it "contains the map's area" do
    @chart.area = "usa"
    @chart.query_params.keys.include?("chtm").should be_true
    @chart.query_params["chtm"].should == "usa"
  end
  
  it "defaults to a blank map" do
    @chart.query_params["chd"].should =~ /^[es]:__?/
  end
  
  it "checks for a valid area" do
    lambda { @chart.area = 'usa' }.should_not raise_error(ArgumentError)
    lambda { @chart.area = 'mars' }.should raise_error(ArgumentError)
  end
  
  it "makes sure the areas have one value" do
    @chart.data = [['NY',1],['VA',2],['WY',3]]
    @chart.area_codes.length.should == @chart.data.size * 2
  end
end

describe GChart::Map, "#data" do
  it "accepts data as a hash or pair of arrays" do
    lambda { GChart::Map.new(:data => {"VA"=>5}) }.should_not raise_error(ArgumentError)
    lambda { GChart::Map.new(:data => {"VA"=>5, "NY"=>1}) }.should_not raise_error(ArgumentError)
    lambda { GChart::Map.new(:data => [["VA",5],["NY",1]]) }.should_not raise_error(ArgumentError)
    lambda { GChart::Map.new(:data => [["VA","NY"],[5,1]]) }.should raise_error(ArgumentError)
    lambda { GChart::Map.new(:data => [1, 2, 3]) }.should raise_error(ArgumentError)
    lambda { GChart::Map.new(:data => [[1, 2, 3]]) }.should raise_error(ArgumentError)
  end
end
