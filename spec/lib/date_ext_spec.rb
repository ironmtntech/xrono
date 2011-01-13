require 'spec_helper'

describe Date do
  before :all do
    @friday = Date.parse('2010-10-15')
    @monday = Date.parse('2010-10-18')
    @tuesday = Date.parse('2010-10-19')
  end

  context "when determining the previous working day" do

    it "should have a prev_working_day method" do
      @monday.respond_to?(:prev_working_day).should be true
    end

    it "should return monday when run on a tuesday" do
      @tuesday.prev_working_day.should == @monday
    end

    it "should return friday when run on a monday" do
      @monday.prev_working_day.should == @friday
    end

  end

  context "when determining the next working day" do

    it "should have a next_working_day method" do
      @monday.respond_to?(:next_working_day).should be true
    end

    it "should return tuesday when run on a monday" do
      @monday.next_working_day.should == @tuesday
    end

    it "should return monday when run on a friday" do
      @friday.next_working_day.should == @monday
    end

  end

end
