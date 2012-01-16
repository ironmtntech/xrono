require File.expand_path("#{File.dirname(__FILE__)}/helper")

describe GChart do
  it "supplies a version" do
    GChart::VERSION.should_not be_nil
  end
end

describe GChart, ".encode" do
  it "supports the simple, text, and extended encoding" do
    lambda { GChart.encode(:simple, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GChart.encode(:text, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GChart.encode(:extended, 4, 10) }.should_not raise_error(ArgumentError)
    lambda { GChart.encode(:monkey, 4, 10) }.should raise_error(ArgumentError)
  end
  
  it "implements the simple encoding" do
    expected = {
      0 => "A", 19 => "T", 27 => "b", 53 => "1", 61 => "9",
      12 => "M", 39 => "n", 57 => "5", 45 => "t", 51 => "z"
    }
    
    expected.each do |original, encoded|
      GChart.encode(:simple, original, 61).should == encoded
    end
  end
  
  it "implements the text encoding" do
    expected = {
      0 => "0.0", 10 => "10.0", 58 => "58.0", 95 => "95.0", 30 => "30.0", 8 => "8.0", 63 => "63.0", 100 => "100.0"
    }
    
    expected.each do |original, encoded|
      GChart.encode(:text, original, 100).should == encoded
    end
  end

  it "implements the extended encoding" do
    expected = {
      0 => "AA", 25 => "AZ", 26 => "Aa", 51 => "Az", 52 => "A0", 61 => "A9", 62 => "A-", 63 => "A.",
      64 => "BA", 89 => "BZ", 90 => "Ba", 115 => "Bz", 116 => "B0", 125 => "B9", 126 => "B-", 127 => "B.",
      4032 => ".A", 4057 => ".Z", 4058 => ".a", 4083 => ".z", 4084 => ".0", 4093 => ".9", 4094 => ".-", 4095 => ".."
    }
    
    expected.each do |original, encoded|
      GChart.encode(:extended, original, 4095).should == encoded
    end
  end
  
  it "encodes nil correctly" do
    GChart.encode(:simple, nil, 1).should == "_"
    GChart.encode(:text, nil, 1).should == "-1"
    GChart.encode(:extended, nil, 1).should == "__"
  end
  
  it "encodes 0 with a max of 0 correctly" do
    GChart.encode(:extended, 0, 0).should == "AA"
  end
end

describe GChart, ".line" do
  it "can render a basic line URL" do
    expected = { "cht" => "lc", "chs" => "300x200", "chd" => "e:AAAp..", "chtt" => "test" }
    chart = GChart.line(:title => "test", :data => [1, 100, 10000])

    chart.query_params.should == expected
    chart.to_url.should == "http://chart.apis.google.com/chart?chs=300x200&cht=lc&chtt=test&chd=e:AAAp.."
  end
end
