require 'spec_helper'

describe Date do
  let(:friday) { Date.parse('2010-10-15') }
  let(:monday) { Date.parse('2010-10-18') }
  let(:tuesday) { Date.parse('2010-10-19') }

  context "when determining the previous working day" do

    it "has a prev_working_day method" do
      monday.respond_to?(:prev_working_day).should be true
    end

    it "returns monday when run on a tuesday" do
      tuesday.prev_working_day.should == monday
    end

    it "returns friday when run on a monday" do
      monday.prev_working_day.should == friday
    end

  end

  context "when determining the next working day" do

    it "has a next_working_day method" do
      monday.respond_to?(:next_working_day).should be true
    end

    it "returns tuesday when run on a monday" do
      monday.next_working_day.should == tuesday
    end

    it "returns monday when run on a friday" do
      friday.next_working_day.should == monday
    end

  end

end
