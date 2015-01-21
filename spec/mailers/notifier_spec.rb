require "spec_helper"

describe Notifier do

  it "has the method to send work unit notifications" do
    expect(Notifier.respond_to?(:work_unit_notification)).to be(true)
  end

end
