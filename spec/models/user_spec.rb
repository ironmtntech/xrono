require 'spec_helper'

describe User do
  let(:user) { User.make }
  let(:user2) { User.make }
  let(:work_unit1) { WorkUnit.make(:user => user) }
  let(:work_unit2) { WorkUnit.make(:user => user) }
  let(:work_unit3) { WorkUnit.make(:user => user) }

  it { should validate_presence_of :first_name }
  it { should validate_presence_of :last_name }

  describe '#with_unpaid_work_units' do
    subject { User.with_unpaid_work_units }

    before do
      work_unit1.update_attributes(:paid => nil, :paid_at => nil)
      work_unit2.update_attributes(:paid => nil, :paid_at => nil)
    end

    it 'should return a collection of users who have unpaid work units' do
      should == [user]
    end
  end

  describe '#unlocked' do
    subject { User.unlocked }

    before { user.unlock_access! }

    it 'should return a collection of users who are not locked' do
      should == [user]
    end
  end

  describe '#sort_by_name' do
    subject { User.sort_by_name }

    before do
      user.update_attribute(:first_name, 'Aaron')
      user2.update_attribute(:first_name, 'Zed')
    end

    it 'should return a collection of users sorted by first name' do
      should == [user, user2]
    end
  end

  describe '.initials' do
    subject { user.initials }

    before { user.update_attributes(:first_name => 'Aaron', :middle_initial => 'B', :last_name => 'Crenshaw') }

    it 'should return the initials of the user' do
      should == 'ABC'
    end
  end

  describe '.work_units_for_day' do
    subject { user.work_units_for_day(Date.current) }

    before do
      work_unit1.update_attributes(:scheduled_at => Date.current)
      work_unit2.update_attributes(:scheduled_at => Date.yesterday)
    end

    it 'should return a collection of work units for the user scheduled on a given day' do
      should == [work_unit1]
    end
  end

  describe '.clients_for_day' do
    subject { user.clients_for_day(Date.current) }

    before do
      work_unit1.update_attributes(:scheduled_at => Date.current)
      work_unit2.update_attributes(:scheduled_at => Date.yesterday)
    end

    context 'when the user has work units scheduled for a given day' do
      it 'should return a collection of clients for those work units' do
        should == [work_unit1.client]
      end
    end
  end

  describe '.work_units_for_week' do
    subject { user.work_units_for_week(Date.current) }

    before do
      work_unit1.update_attributes(:scheduled_at => Date.current)
      work_unit2.update_attributes(:scheduled_at => Date.current - 1.week)
    end

    it 'should return a collection of work units for the user scheduled during the week of a given day' do
      should == [work_unit1]
    end
  end

  describe '.unpaid_work_units' do
    subject { user.unpaid_work_units }

    before do
      work_unit1.update_attributes(:paid => nil, :paid_at => nil)
      work_unit2.update_attributes(:paid => 'True', :paid_at => Date.current)
      work_unit3.update_attributes(:user => user2)
    end

    it 'should return a collection of work units which are unpaid and belong to the user' do
      should == [work_unit1]
    end
  end

  describe '.to_s' do
    subject { user.to_s }

    before { user.update_attributes(:first_name => 'Aaron', :middle_initial => 'B', :last_name => 'Crenshaw') }

    it 'should return the first name, middle initial, and last name for the user' do
      should == 'Aaron B Crenshaw'
    end
  end

  describe '.admin?' do
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

  describe '.locked' do
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

  describe '.pto_hours_left' do
    subject { user.pto_hours_left(Date.parse('2011-01-01')) }

    let(:site_settings) { SiteSettings.make }

    before do
      site_settings.update_attributes(:total_yearly_pto_per_user => 40)
      work_unit1.update_attributes(:hours => 2, :hours_type => 'PTO', :scheduled_at => '2011-01-01')
      work_unit2.update_attributes(:hours => 3, :hours_type => 'PTO', :scheduled_at => '2011-12-31')
      work_unit3.update_attributes(:hours => 5, :hours_type => 'PTO', :scheduled_at => '2010-12-31')
    end

    it 'should return the number of PTO hours left for the given year' do
      should == 35
    end
  end

  describe 'while being created' do
    it 'should create a new user from the blueprint' do
      lambda do
        User.make
      end.should change(User, :count).by(1)
    end
  end

end
