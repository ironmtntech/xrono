require 'spec_helper'

describe Ticket do
  let(:ticket) { Ticket.make(:name => 'New Ticket') }

  it { should belong_to :project }
  it { should have_many :work_units }
  it { should have_many :file_attachments }

  it { should validate_presence_of :project_id }
  it { should validate_presence_of :name }

  describe '#to_s' do
    subject { ticket.to_s }

    it 'returns the name of the ticket as a string' do
      should == 'New Ticket'
    end
  end

  describe '#client' do
    context 'when a ticket exists' do
      it 'returns the client' do
        ticket.client.should == ticket.project.client
      end
    end
  end

  describe '#unpaid_hours' do
    context 'when there are unpaid work units on a ticket' do
      it 'totals the unpaid hours for that ticket' do
        work_unit_1 = WorkUnit.make(:ticket => ticket)
        work_unit_2 = WorkUnit.make(:ticket => ticket)
        work_unit_3 = WorkUnit.make(:ticket => ticket, :paid => 'paid on 2010-10-25')
        unpaid_hours = work_unit_1.effective_hours + work_unit_2.effective_hours

        ticket.unpaid_hours.should == unpaid_hours
      end
    end
  end

  describe '#uninvoiced_hours' do
    context 'when there are uninvoiced work units on a ticket' do
      it 'returns the total number of uninvoiced work units for that ticket' do
        ticket = Ticket.make
        work_unit_1 = WorkUnit.make(:ticket => ticket)
        work_unit_2 = WorkUnit.make(:ticket => ticket)
        work_unit_3 = WorkUnit.make(:ticket => ticket, :invoiced => 'invoiced on 2010-10-25')
        uninvoiced_hours = work_unit_1.effective_hours + work_unit_2.effective_hours

        ticket.uninvoiced_hours.should == uninvoiced_hours
      end
    end
  end

  describe '#long_name' do
    it 'returns a descriptive string with the ticket id, project, and client' do
      long_name = "Ticket: [#{ticket.id}] - #{ticket.project.name} - #{ticket.name} ticket for #{ticket.project.client.name}"

      ticket.long_name.should == long_name
    end
  end

  describe '#allows_access?' do
    let(:project) { Project.make }
    let(:ticket) { Ticket.make(:project => project) }
    let(:user) { User.make }

    it 'returns false if the user does not have access to the parent project' do
      ticket.allows_access?(user).should be_false
    end

    it 'returns true if the user has access to the parent project' do
      user.has_role!(:developer, project)
      ticket.allows_access?(user).should be_true
    end
  end

  describe '.for_user_role' do
    context 'when a user has access to a project' do
      let(:project_1) { Project.make }
      let(:project_2) { Project.make }
      let(:user) do
        _user = User.make
        _user.has_role!(:developer, project_1)
        _user.has_role!(:client, project_2)
        _user
      end
      let!(:ticket_1) { Ticket.make(:project => project_1) }
      let!(:ticket_2) { Ticket.make(:project => project_1) }
      let!(:ticket_3) { Ticket.make(:project => project_2) }

      it 'returns a collection of tickets for all the projects to which the user is assigned' do
        Ticket.for_user_and_role(user, "developer").include?(ticket_1).should be_true
        Ticket.for_user_and_role(user, "developer").include?(ticket_2).should be_true
        Ticket.for_user_and_role(user, "developer").include?(ticket_3).should be_false
      end
    end
  end

  describe '.for_user' do
    context 'when a user has access to a project' do
      let(:project_1) { Project.make }
      let(:project_2) { Project.make }
      let(:user) do
        _user = User.make
        _user.has_role!(:developer, project_1)
        _user
      end
      let!(:ticket_1) { Ticket.make(:project => project_1) }
      let!(:ticket_2) { Ticket.make(:project => project_1) }
      let!(:ticket_3) { Ticket.make(:project => project_2) }

      it 'returns a collection of tickets for all the projects to which the user is assigned' do
        Ticket.for_user(user).include?(ticket_1).should be_true
        Ticket.for_user(user).include?(ticket_2).should be_true
        Ticket.for_user(user).include?(ticket_3).should be_false
      end
    end
  end

  describe 'returns a list of tickets using' do
    let(:project) { Project.make }

    let!(:ticket) do
      _ticket = project.tickets.make
      _ticket.update_attribute(:git_branch, 'feature/test')
      _ticket
    end

    it ".for_repo_and_branch" do
      project.update_attribute(:git_repo_name, 'test')
      Ticket.for_repo_and_branch("test", "feature/test").should include(ticket)
    end

    it ".for_repo_url_and_branch" do
      project.update_attribute(:git_repo_url, 'test')
      Ticket.for_repo_url_and_branch("test", "feature/test").should include(ticket)
    end
  end

  describe '' do
    let(:ticket) do
      _ticket = Ticket.make
      _ticket.update_attribute(:estimated_hours, 10)
      _ticket
    end

    let(:work_unit_is_under) do
      wu = ticket.work_units.make
      wu.update_attribute(:effective_hours, 5)
      wu
    end

    describe '#remaining_hours' do
      let(:work_unit_is_over) do
        wu = ticket.work_units.make
        wu.update_attribute(:effective_hours, 11)
        wu
      end

      it 'returns the remaining hours when there are remaining hours' do
        work_unit_is_under

        ticket.remaining_hours.should == 5
      end

      it 'returns 0 when there are more effective hours than estimated hours' do
        work_unit_is_over

        ticket.remaining_hours.should == 0
      end
    end

    describe '#percentage_complete' do
      let(:ticket_invalid) { Ticket.make }

      it 'calculates the percentage left on the ticket' do
        work_unit_is_under

        ticket.percentage_complete.should == 50.0
      end

      it 'returns 0 when there is an error' do
        ticket_invalid.percentage_complete.should == 0
      end
    end
  end

  describe '#hours' do
    context 'when there are normal work units with hours' do
      let(:ticket_2) { Ticket.make }

      it 'returns the correct sum of hours for those work units' do
        work_unit_1 = WorkUnit.make(:ticket => ticket, :hours => '1.0', :hours_type => 'Normal')
        work_unit_2 = WorkUnit.make(:ticket => ticket, :hours => '1.0', :hours_type => 'Normal')
        work_unit_3 = WorkUnit.make(:ticket => ticket_2, :hours => '1.0', :hours_type => 'Normal')

        ticket.hours.should == 2.0
      end
    end
  end

  describe 'while being created' do
    it 'creates a new ticket from the blueprint' do
      lambda do
        Ticket.make
      end.should change(Ticket, :count).by(1)
    end
  end

  describe '#files_and_comments' do
    it 'lists all files and comments' do
      ticket = Ticket.make
      comment = ticket.comments.create(:title => "test", :comment => "test")
      File.open("tmp/tmp.txt", "w") {|f| f.write "test"}
      fa = ticket.file_attachments.create(:attachment_file => File.open("tmp/tmp.txt","r"))
      ticket.files_and_comments.should == [comment,fa]
      File.delete("tmp/tmp.txt")
    end
  end

end
