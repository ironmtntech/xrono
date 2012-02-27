require "spec_helper"

describe Notifier do

  it "includes Resque::Mailer" do
    Notifier.included_modules.include?(Resque::Mailer).should be_true
  end

  it "has the method to send work unit notifications" do
    Notifier.respond_to?(:work_unit_notification).should be_true
  end

end
