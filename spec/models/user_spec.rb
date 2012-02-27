require 'spec_helper'

describe User do
  let(:user) { User.make }
  let(:user_2) { User.make }
  let(:work_unit1) { WorkUnit.make(:user => user) }
  let(:work_unit2) { WorkUnit.make(:user => user) }
  let(:work_unit3) { WorkUnit.make(:user => user) }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }
  describe '.with_unpaid_work_units' do
    subject { User.with_unpaid_work_units }

    before do
      work_unit1.update_attributes(:paid => nil, :paid_at => nil)
      work_unit2.update_attributes(:paid => nil, :paid_at => nil)
    end

    it 'returns a collection of users who have unpaid work units' do
      should == [user]
    end
  end

  describe '.unlocked' do
    subject { User.unlocked }

    before { user.unlock_access! }

    it 'returns a collection of users who are not locked' do
      should == [user]
    end
  end

  describe '.sort_by_name' do
    subject { User.sort_by_name }

    before do
      user.update_attribute(:first_name, 'Aaron')
      user_2.update_attribute(:first_name, 'Zed')
    end

    it 'returns a collection of users sorted by first name' do
      should == [user, user_2]
    end
  end

  describe '#initials' do
    subject { user.initials }

    before { user.update_attributes(:first_name => 'Aaron', :middle_initial => 'B', :last_name => 'Crenshaw') }

    it 'returns the initials of the user' do
      should == 'ABC'
    end
  end

  describe '#work_units_for_day' do

    before do
      work_unit1.update_attributes(:scheduled_at => Time.now)
      work_unit2.update_attributes(:scheduled_at => 1.days.ago)
    end

    it 'returns a collection of work units for the user scheduled on a given day' do
      user.work_units_for_day(Time.now).should == [work_unit1]
    end

    it "sums up all work units' hours  for the user scheduled on a given day" do
      work_unit1.update_attributes(:hours => 3)
      work_unit2.update_attributes(:hours => 1, :scheduled_at => Time.now)
      user.hours_entered_for_day(Time.now).should == 4
    end
  end

  describe '.clients_for_day' do
    subject { user.clients_for_day(Time.now) }

    before do
      work_unit1.update_attributes(:scheduled_at => Time.now)
      work_unit2.update_attributes(:scheduled_at => Time.now - 1.day)
    end

    context 'when the user has work units scheduled for a given day' do
      it 'returns a collection of clients for those work units' do
        should == [work_unit1.client]
      end
    end
  end

  describe '#work_units_for_week' do
    subject { user.work_units_for_week(Time.now) }

    before do
      work_unit1.update_attributes(:scheduled_at => Time.now)
      work_unit2.update_attributes(:scheduled_at => Time.now - 1.week)
    end

    it 'returns a collection of work units for the user scheduled during the week of a given day' do
      should == [work_unit1]
    end
  end

  describe '#unpaid_work_units' do
    subject { user.unpaid_work_units }

    before do
      work_unit1.update_attributes(:paid => nil, :paid_at => nil)
      work_unit2.update_attributes(:paid => 'True', :paid_at => Time.now)
      work_unit3.update_attributes(:user => user_2)
    end

    it 'returns a collection of work units which are unpaid and belong to the user' do
      should == [work_unit1]
    end
  end

  describe '.for_project' do
    let(:project) { Project.make }
    before(:each) { user.has_role!("developer", project) }

    it 'returns all the users listed on a project' do
      User.for_project(project).should == [user]
    end
  end

  describe '#to_s' do
    subject { user.to_s }

    before { user.update_attributes(:first_name => 'Aaron', :middle_initial => 'B', :last_name => 'Crenshaw') }

    it 'returns the first name, middle initial, and last name for the user' do
      should == 'Aaron B Crenshaw'
    end
  end

  describe '#admin?' do
    subject { user.admin? }

    context 'when the user has an admin role' do
      before { user.has_role!(:admin) }
      it { should be_true }
    end

    context 'when the user does not have an admin role' do
      before { user.has_no_role!(:admin) }
      it { should be_false }
    end
  end

  describe '#locked' do
    subject { user.locked }

    context 'when the user is locked' do
      before { user.lock_access! }
      it { should be_true }
    end

    context 'when the user is unlocked' do
      before { user.unlock_access! }
      it { should be_false }
    end
  end

  describe '#pto_hours_left' do
    subject { user.pto_hours_left(Date.today.end_of_year) }

    let(:site_settings) { SiteSettings.make }

    before do
      site_settings.update_attributes(:total_yearly_pto_per_user => 40)
      work_unit1.update_attributes(:hours => 2, :hours_type => 'PTO', :scheduled_at => Date.today)
      work_unit2.update_attributes(:hours => 3, :hours_type => 'PTO', :scheduled_at => 1.days.from_now)
      work_unit3.update_attributes(:hours => 5, :hours_type => 'PTO', :scheduled_at => '2010-12-31')
    end

    it 'returns the number of PTO hours left for the given year as of the passed date' do
      should == 35
    end
  end

  describe 'while being created' do
    it 'creates a new user from the blueprint' do
      lambda do
        User.make
      end.should change(User, :count).by(1)
    end
  end

  describe 'target_hours_offset' do
    subject { user.target_hours_offset(Date.current) }

    it 'raises an error on non-date objects' do
      lambda{ user.target_hours_offset(Time.now) }.should raise_error(RuntimeError)
    end

    it 'calculates the hours a user needs to meet their daily target hours' do
      should == 0.0
    end
  end

  describe 'expected_hours' do
    subject { user.expected_hours(Date.current).to_s }

    before do
      work_unit1.update_attributes(:hours => 2, :hours_type => 'Normal', :scheduled_at => Date.yesterday)
    end

    it 'raises an error if not passed a date' do
      lambda do
        user.expected_hours(Time.now)
      end.should raise_error(RuntimeError)
    end

    it 'calculates the expected hours for a user' do
      should =~ /\d+/
    end

    context 'user has been here all year' do
      before do
        work_unit1.update_attributes(:hours => 2, :hours_type => 'Normal', :scheduled_at => Date.current.years_ago(1))
      end
      it { should =~ /\d+/}
    end
  end

  describe 'percentage_work_for' do
    subject { user.percentage_work_for(Client.new, Date.yesterday, Date.current) }

    it 'raises an exception if the client is not a Client' do
      lambda do
        user.percentage_work_for(User.new, Date.yesterday, Date.current)
      end.should raise_error(RuntimeError)
    end

    it 'raises an exception if the start_date is not a Date' do
      lambda do
        user.percentage_work_for(Client.new, 1.days.ago, Date.current)
      end.should raise_error(RuntimeError)
    end

    it 'raises an exception if the end_date is not a Date' do
      lambda do
        user.percentage_work_for(Client.new, Date.yesterday, Time.now)
      end.should raise_error(RuntimeError)
    end

    it 'does not raise an exception if given the right parameter types' do
      lambda do
        user.percentage_work_for(client, start_date, end_date)
      end.should_not raise_error(RuntimeError)
    end

    it 'calculates the percentage of hours worked for a client as a percentage of all work done' do
      should == 0
    end
  end
end
