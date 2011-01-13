require 'spec_helper'

describe Project do
  before { @project = Project.make(:name => 'New Project') }

  it { should belong_to :client }
  it { should have_many :tickets }
  it { should have_many :comments }
  it { should have_many :file_attachments }

  it { should validate_presence_of :name }
  it { should validate_presence_of :client_id }
  it { should validate_uniqueness_of(:name).scoped_to(:client_id) }

  describe '.to_s' do
    subject { @project.to_s }

    it 'returns the name of the project as a string' do
      should == 'New Project'
    end
  end

  describe '.hours' do
    it 'should return total number of hours from all tickets on the project' do
      project = Project.make
      ticket_1 = Ticket.make(:project => project)
      ticket_2 = Ticket.make(:project => project)
      WorkUnit.make(:ticket => ticket_1)
      WorkUnit.make(:ticket => ticket_2)
      project.hours.should == ticket_1.work_units.first.effective_hours + ticket_2.work_units.first.effective_hours
    end
  end

  describe '.uninvoiced_hours' do
    it "returns the sum of hours on all the client's work units" do
      work_unit_1 = WorkUnit.make
      ticket = work_unit_1.ticket
      project = work_unit_1.project
      work_unit_2 = WorkUnit.make(:ticket => ticket)
      work_unit_3 = WorkUnit.make(:ticket => ticket, :invoiced => 'Invoiced', :invoiced_at => Time.current)
      total_hours = work_unit_1.effective_hours + work_unit_2.effective_hours
      project.uninvoiced_hours.should == total_hours
    end
  end

  describe '#for_user' do
    context 'when a user is assigned to a project' do
      it 'returns the projects to which the user is assigned' do
        user = User.make
        project1 = Project.make
        project2 = Project.make
        user.has_no_roles_for!(project2)
        user.has_role!(:developer, project1)
        Project.for_user(user).include?(project1).should be_true
        Project.for_user(user).include?(project2).should be_false
      end
    end
  end

  describe '.work_units' do
    it 'returns the children work units for that project' do
      work_unit = WorkUnit.make
      project = work_unit.ticket.project
      project.work_units.should == [work_unit]
    end
  end

  describe 'while being created' do
    it 'should create a new project from the blueprint' do
      lambda do
        Project.make
      end.should change(Project, :count).by(1)
    end
  end

end

