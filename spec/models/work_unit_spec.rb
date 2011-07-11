require 'spec_helper'

describe WorkUnit do
  let(:work_unit) { WorkUnit.make }
  let(:work_unit1) { WorkUnit.make }
  let(:work_unit2) { WorkUnit.make }
  let(:site_settings) { SiteSettings.make }

  it { should have_many :comments }
  it { should belong_to :ticket }
  it { should belong_to :user }

  it { should validate_presence_of :ticket_id }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :description }
  it { should validate_presence_of :hours }
  it { should validate_presence_of :scheduled_at }
  it { should validate_presence_of :effective_hours }


  describe '#scheduled_between' do
    subject { WorkUnit.scheduled_between(1.days.ago.beginning_of_day, Time.now.end_of_day)  }

    before do
      work_unit1.update_attribute(:scheduled_at, 1.days.ago)
      work_unit2.update_attribute(:scheduled_at, Time.now)
    end

    it 'should return a collection of work units scheduled between the two given dates' do
      should == [work_unit1, work_unit2]
    end
  end

  describe '.unpaid' do
    subject { WorkUnit.unpaid }

    before do
      work_unit1.update_attributes(:paid => 'Paid', :paid_at => Date.current)
      work_unit2.update_attributes(:paid => nil, :paid_at => nil)
    end

    it 'should return a collection of work units which are unpaid' do
      should == [work_unit2]
    end
  end

  describe '.not_invoiced' do
    subject { WorkUnit.not_invoiced }

    before do
      work_unit1.update_attributes(:invoiced => 'Invoiced', :invoiced_at => Date.current)
      work_unit2.update_attributes(:invoiced => nil, :invoiced_at => nil)
    end

    it 'should return a collection of work units which are not invoiced' do
      should == [work_unit2]
    end
  end

  describe '.for_client' do
    subject { WorkUnit.for_client client }

    let(:ticket) { Ticket.make }
    let(:client) { ticket.client }

    before do
      work_unit1.update_attribute(:ticket, ticket)
      work_unit2.update_attribute(:ticket, ticket)
    end

    it 'should return a collection of work units that belong to the given client' do
      should == [work_unit1, work_unit2]
    end
  end

  describe '.for_project' do
    subject { WorkUnit.for_project project }

    let(:ticket) { Ticket.make }
    let(:project) { ticket.project }

    before do
      work_unit1.update_attribute(:ticket, ticket)
      work_unit2.update_attribute(:ticket, ticket)
    end

    it 'should return a collection of work units that belong to the given project' do
      should == [work_unit1, work_unit2]
    end
  end

  describe '.for_ticket' do
    subject { WorkUnit.for_ticket ticket }

    let(:ticket) { Ticket.make }

    before do
      work_unit1.update_attribute(:ticket, ticket)
      work_unit2.update_attribute(:ticket, ticket)
    end

    it 'should return a collection of work units that belong to the given ticket' do
      should == [work_unit1, work_unit2]
    end
  end

  describe '.for_user' do
    subject { WorkUnit.for_user user }

    let(:user) { User.make }

    before do
      work_unit1.update_attribute(:user, user)
      work_unit2.update_attribute(:user, user)
    end

    it 'should return a collection of work units that belong to the given user' do
      should == [work_unit1, work_unit2]
    end
  end

  describe '.sort_by_scheduled_at' do
    subject { WorkUnit.sort_by_scheduled_at }

    before do
      work_unit1.update_attribute(:scheduled_at, Date.yesterday)
      work_unit2.update_attribute(:scheduled_at, Date.current)
    end

    it 'should return a collection of work units sorted by scheduled time, descending' do
      should == [work_unit2, work_unit1]
    end
  end

  describe ".hours" do
    subject { WorkUnit.hours}

    it "should not allow negative numbers" do
      work_unit1.update_attribute(:hours, -1)
      work_unit1.should_not be_valid
    end

    it "should not accept characters" do
      work_unit1.update_attribute(:hours, "asdf#")
      work_unit1.should_not be_valid
    end
  end


  describe '.pto' do
    subject { WorkUnit.pto }

    before do
      work_unit1.update_attribute(:hours_type, 'PTO')
      work_unit2.update_attribute(:hours_type, 'Normal')
    end

    it 'should return a collection of work units with hours type "PTO"' do
      should == [work_unit1]
    end
  end

  describe '.cto' do
    subject { WorkUnit.cto }

    before do
      work_unit1.update_attribute(:hours_type, 'CTO')
      work_unit2.update_attribute(:hours_type, 'Normal')
    end

    it 'should return a collection of work units with hours type "CTO"' do
      should == [work_unit1]
    end
  end

  describe '.overtime' do
    subject { WorkUnit.overtime }

    before do
      work_unit1.update_attribute(:hours_type, 'Overtime')
      work_unit2.update_attribute(:hours_type, 'Normal')
    end

    it 'should return a collection of work units with hours type "Overtime"' do
      should == [work_unit1]
    end

    it 'should return true if hours type is overtime' do
      work_unit1.overtime?.should == true
    end
  end

  

  describe '.normal' do
    subject { WorkUnit.normal }

    before do
      work_unit1.update_attribute(:hours_type, 'Overtime')
      work_unit2.update_attribute(:hours_type, 'Normal')
    end

    it 'should return a collection of work units with hours type "Normal"' do
      should == [work_unit2]
    end
  end

  describe '#validate_client_status' do
    subject { work_unit.validate_client_status }

    let(:client) { work_unit.client }

    context 'when the client status is "Inactive"' do
      before { client.status = "Inactive" }

      it { should raise_error }
    end
  end

  describe '#send_email!' do
    context 'when there are contacts for the parent client who receive email' do
      let(:contact1) { Contact.make(:client => work_unit.client) }
      let(:contact2) { Contact.make(:client => work_unit.client) }

      before do
        contact1.update_attribute(:receives_email, true)
        contact2.update_attribute(:receives_email, false)
      end

      it 'should send the email' do
        lambda { work_unit.send_email! }.should change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

#  describe '#not_send_email!' do
#    context 'when there are NO contacts for the parent client who receive email' do
#
#      it 'should not send the email' do
#        lambda { work_unit.send_email! }.should_not change(ActionMailer::Base.deliveries, :count).by(1)
#      end
#    end
#  end

  describe '#email_list' do
    subject { work_unit.email_list }

    context 'when there are contacts for the parent client who receive email' do
      let(:contact1) { Contact.make(:client => work_unit.client) }
      let(:contact2) { Contact.make(:client => work_unit.client) }

      before do
        contact1.update_attribute(:receives_email, true)
        contact2.update_attribute(:receives_email, false)
      end

      it 'should return a collection of email addresses for those contacts' do
        should == [contact1.email_address]
      end
    end
  end

  describe '#client' do
    subject { work_unit.client }

    it 'should return the parent client' do
      should == work_unit.ticket.project.client
    end
  end

  describe '#project' do
    subject { work_unit.project }

    it 'should return the parent project' do
      should == work_unit.ticket.project
    end
  end

  describe '#unpaid?' do
    subject { work_unit.unpaid? }

    context 'when the work unit is unpaid' do
      before { work_unit.update_attributes(:paid => nil, :paid_at => nil) }
      it { should be_true }
    end

    context 'when the work unit is paid' do
      before { work_unit.update_attributes(:paid => 'Paid', :paid_at => Date.current) }
      it { should be_false }
    end
  end

  describe '#paid?' do
    subject { work_unit.paid? }

    context 'when the work unit is unpaid' do
      before { work_unit.update_attributes(:paid => nil, :paid_at => nil) }
      it { should be_false }
    end

    context 'when the work unit is paid' do
      before { work_unit.update_attributes(:paid => 'Paid', :paid_at => Date.current) }
      it { should be_true }
    end
  end

  describe '#invoiced?' do
    subject { work_unit.invoiced? }

    context 'when the work unit is invoiced' do
      before { work_unit.update_attributes(:invoiced => 'Invoiced', :invoiced_at => Date.current) }
      it { should be_true }
    end

    context 'when the work unit is not invoiced' do
      before { work_unit.update_attributes(:invoiced => nil, :invoiced_at => nil) }
      it { should be_false }
    end
  end

  describe '#not_invoiced?' do
    subject { work_unit.not_invoiced? }

    context 'when the work unit is invoiced' do
      before { work_unit.update_attributes(:invoiced => 'Invoiced', :invoiced_at => Date.current) }
      it { should be_false }
    end

    context 'when the work unit is not invoiced' do
      before { work_unit.update_attributes(:invoiced => nil, :invoiced_at => nil) }
      it { should be_true }
    end
  end

  describe '#to_s' do
    subject { work_unit.to_s }

    before { work_unit.update_attribute(:description, 'New description') }

    it 'returns the description' do
      should == 'New description'
    end
  end

  describe '#allows_access?' do
    subject { work_unit.allows_access? user }

    let(:user) { User.make }

    context 'when the user has a role on the parent project' do
      before { user.has_role!(:developer, work_unit.project) }
      it { should be_true }
    end

    context 'when the user has an admin role' do
      before { user.has_role!(:admin) }
      it { should be_true }
    end

    context 'when the user has no role on the parent project' do
      before { user.has_no_roles_for!(work_unit.project) }
      it { should be_false }
    end
  end

  describe '#overtime_multiplier' do
    subject { work_unit.overtime_multiplier }

    let(:project) { work_unit.project }
    let(:client) { work_unit.client }
    let(:site_settings) { SiteSettings.create }

    context 'when the project and client have an overtime multiplier' do
      before do
        project.update_attribute(:overtime_multiplier, 3.0)
        client.update_attribute(:overtime_multiplier, 2.5)
        site_settings.update_attribute(:overtime_multiplier, 2.0)
      end

      it 'should return the project overtime multiplier' do
        should == 3
      end
    end

    context 'when the client has an overtime multiplier' do
      before do
        project.update_attribute(:overtime_multiplier, nil)
        client.update_attribute(:overtime_multiplier, 2.5)
        site_settings.update_attribute(:overtime_multiplier, 2.0)
      end

      it 'should return the client overtime multiplier' do
        should == 2.5
      end
    end

    context 'when neither the project nor the client have an overtime multiplier' do
      before do
        project.update_attribute(:overtime_multiplier, nil)
        client.update_attribute(:overtime_multiplier, nil)
        site_settings.update_attribute(:overtime_multiplier, 2.0)
      end

      it 'should return the site settings overtime multiplier' do
        should == 2
      end
    end

    context 'when there is no site settings overtime multiplier' do
      before do
        project.overtime_multiplier = nil
        client.overtime_multiplier = nil
        site_settings.overtime_multiplier = nil
      end

      it 'should default to 1.5' do
        should == 1.5
      end
    end
  end

  describe '#set_effective_hours!' do
    context 'when saving an overtime work unit' do
      before do
        work_unit.project.update_attribute(:overtime_multiplier, 1.5)
        work_unit.update_attributes(:hours => 2, :hours_type => 'Overtime')
      end

      it 'applies the overtime_multiplier' do
        work_unit.effective_hours.should == 3
      end
    end

    context 'when saving a normal work_unit' do
      before do
        work_unit.project.update_attribute(:overtime_multiplier, 1.5)
        work_unit.update_attributes(:hours => 2, :hours_type => 'Normal')
      end

      it 'does not apply the overtime multiplier' do
        work_unit.effective_hours.should == 2
      end
    end
  end

end
