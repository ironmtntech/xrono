require 'spec_helper'

describe Client do
  let(:user) { User.make }
  let(:client) { Client.make(:name => 'New Client', :status => 'Active') }
  let(:project) { Project.make(:client => client)  }
  let(:ticket)  { Ticket.make(:project => project) }
  let(:work_unit1) { WorkUnit.make(:ticket => ticket) }
  let(:work_unit2) { WorkUnit.make(:ticket => ticket) }
  let(:work_unit3) { WorkUnit.make(:ticket => ticket) }

  subject { client }

  it { should have_many :projects }
  it { should have_many(:tickets).through(:projects) }
  it { should have_many :comments }
  it { should have_many :file_attachments }
  it { should have_many :contacts }

  it { should validate_presence_of :name }
  it { should validate_presence_of :status }
  it { should validate_uniqueness_of :name }

  describe '#to_s' do
    subject { client.to_s }
    it 'returns the client name' do
      should == 'New Client'
    end
  end

  describe '#allows_access?' do
    subject { client.allows_access?(user) }

    context 'when the user has access to one or more of its projects' do
      before { user.has_role!(:developer, project) }
      it { should be_true }
    end

    context 'when the user has access to none of its projects' do
      before { user.has_no_roles_for!(project) }
      it { should be_false }
    end
  end

  describe '#uninvoiced_hours' do
    subject { client.uninvoiced_hours }

    context 'when there are invoiced and uninvoiced work units' do
      before do
        work_unit1.update_attributes(:hours => 1, :hours_type => 'Normal')
        work_unit2.update_attributes(:hours => 1, :hours_type => 'Normal')
        work_unit3.update_attributes(:hours => 1, :hours_type => 'Normal', :invoiced => '1', :invoiced_at => Date.current)
      end

      it 'returns the sum of the hours on the uninvoiced work units' do
        should == 2
      end
    end
  end

  describe '#hours' do
    subject { client.hours }

    context 'when there are normal work units with hours' do
      before do
        work_unit1.update_attributes(:hours => 1, :hours_type => 'Normal')
        work_unit2.update_attributes(:hours => 1, :hours_type => 'Normal')
      end

      it 'should return the correct sum of hours for those work units' do
        should == 2
      end
    end
  end

  describe '#tickets' do
    subject { client.tickets }

    context 'when the client has tickets' do
      let(:ticket2) { Ticket.make(:project => project) }

      it 'returns the collection of tickets that belong to the client' do
        should =~ [ticket, ticket2]
      end
    end
  end

  describe '.for_user' do
    subject { Client.for_user user }

    context 'when a user has access to projects of clients' do
      before { user.has_role!(:developer, project) }

      it 'returns a collection of clients to which the user has access' do
        should == [client]
      end
    end
  end

  describe '.for' do
    let(:projects)   { [project] }
    let(:tickets)    { [ticket]  }
    let(:work_units) { [work_unit1, work_unit2, work_unit3] }

    context 'given a collection of projects' do
      subject { Client.for projects }

      it 'returns a unique list of clients for those projects' do
        should == [client]
      end
    end

    context 'given a collection of tickets' do
      subject { Client.for tickets }

      it 'returns a unique list of clients for those tickets' do
        should == [client]
      end
    end

    context 'given a collection of work units' do
      subject { Client.for work_units }

      it 'returns a unique list of clients for those work units' do
        should == [client]
      end
    end
  end

  describe 'while being created' do
    it 'should create a new client from the blueprint' do
      lambda do
        Client.make
      end.should change(Client, :count).by(1)
    end
  end

  describe 'tickets' do
    it 'should return the tickets for the client' do
      client    = Client.make
      project   = client.projects.make
      ticket    = project.tickets.make
      ticket_2  = project.tickets.make
      ticket_3  = Ticket.make
      client.tickets.should =~ [ticket,ticket_2]
    end
  end

  describe 'file_and_comments' do
    let!(:file_attachment) {
      FileAttachment.create!({
        :client_id => client.id,
        :ticket_id => ticket.id,
        :project_id => project.id,
        :attachment_file_file_name => "file.file",
        :created_at => 2.days.ago
      })
    }

    let!(:comment) {
      Comment.create!({
        :title => "Test",
        :comment => "Herro",
        :commentable_id => client.id,
        :created_at => 1.hours.ago,
        :commentable_type => "Client"
      })
    }

    it 'adds file attachments and comments in the correct order' do
      client.files_and_comments.should == [file_attachment, comment]
    end
  end


end

