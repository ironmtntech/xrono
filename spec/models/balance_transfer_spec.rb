require 'spec_helper_no_rails'
load 'lib/balance_transfer.rb'
describe BalanceTransfer do
  before(:each) do
    @user_1 = mock("User 1")
    @user_2 = mock("User 2")
    @users = [@user_1, @user_2]
    @distribution_manager = mock "Distribution Manager"
    @balance_transfer = BalanceTransfer.new(:distribution_manager => @distribution_manager, :users => @users)
  end

  describe "basic setup" do
    it "should default to yesterday" do
      @balance_transfer.date.to_date.should == 1.day.ago.to_date
    end

    it "should accept a different date" do
      balance_transfer = BalanceTransfer.new(:distribution_manager => mock, :users => mock, :date => 5.days.ago)
      balance_transfer.date.to_date.should == 5.days.ago.to_date
    end
  end

  describe "run!" do
    it "should call the correct methods on the users" do
      methods = [:check_daily_time, :ten_day_assessment, :award_pto]
      @users.each do |user|
        methods.each do |method|
          @balance_transfer.should_receive(method).with(user)
        end
      end
      @balance_transfer.run!
    end
  end

  describe "check_daily_time" do
    it "should award per diem if yesterdays hours were 8 or greater" do
      @user_1.should_receive(:hours_entered_for_day).with(@balance_transfer.date).and_return(8)
      @balance_transfer.should_receive(:award_per_diem).with(@user_1).once
      @balance_transfer.should_receive(:add_time_to_offset).with(@user_1).once
      @balance_transfer.should_not_receive(:issue_demerit)
      @balance_transfer.check_daily_time(@user_1)
    end

    it "should add a demerit if the dates hours were less than 8" do
      @user_1.should_receive(:hours_entered_for_day).with(@balance_transfer.date).and_return(7.9)
      @balance_transfer.should_not_receive(:award_per_diem).with(@user_1)
      @balance_transfer.should_receive(:add_time_to_offset).with(@user_1).once
      @balance_transfer.should_receive(:issue_demerit).with(@user_1).once
      @balance_transfer.check_daily_time(@user_1)
    end
  end

  describe "ten_day_assesment" do
    it "should award a remote work day if you've worked more than 70 external hours in the last 10 days" do
      #@balance_transfer.ten_day_assesment(@user_1)
    end
  end
end
