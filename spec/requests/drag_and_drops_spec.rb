require 'spec_helper'

describe "DragAndDrops" do
  describe "GET /projects/1" do
    it "should display the project's ticket" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      response.status.should be(200)
    end
  end
end
