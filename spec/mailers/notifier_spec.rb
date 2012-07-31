require "spec_helper"

describe Notifier do

  it "has the method to send work unit notifications" do
    Notifier.respond_to?(:work_unit_notification).should be_true
  end

end
