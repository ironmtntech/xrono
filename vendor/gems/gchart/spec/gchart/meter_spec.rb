require File.expand_path("#{File.dirname(__FILE__)}/../helper")

describe GChart::Meter do
  it "renders the correct chart type" do
    GChart::Meter.new.render_chart_type.should == "gom"
  end
end

describe GChart::Meter, "#query_params" do
  before(:each) do
    @meter = GChart::Meter.new
    @meter.data = 50
  end  
  it "encodes the data correctly" do
    for data in [70, 70.0, "70", "70.0", "70%"] do
      @meter.data = data
      @meter.query_params["chd"].should == "t:70.0"
    end
  end
  it "allows a label" do
    @meter.label = "Label"
    @meter.query_params.keys.include?("chl").should be_true
    @meter.query_params["chl"].should == "Label"
  end
  it "allows a legend" do
    @meter.legend = "Legend"
    @meter.query_params.keys.include?("chl").should be_true
    @meter.query_params["chl"].should == "Legend"
  end
  it "makes label take precedence over legend" do
    @meter.legend = "Legend"
    @meter.label = "Label"
    @meter.query_params.keys.include?("chl").should be_true
    @meter.query_params["chl"].should == "Label"
  end
  it "complains about more than one label" do
    lambda { @meter.label = "set1" }.should_not raise_error(ArgumentError)
    lambda { @meter.label = ["set1"] }.should_not raise_error(ArgumentError)
    lambda { @meter.label = "set1|set2" }.should raise_error(ArgumentError)
    lambda { @meter.label = ['set1','set2'] }.should raise_error(ArgumentError)    
  end
end

describe GChart::Map, "#render_data" do
  it "allows only one data point" do
    lambda { @meter.data = "set1" }.should_not raise_error(ArgumentError)
  end
end
