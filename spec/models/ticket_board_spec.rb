require 'spec_helper'

describe Ticket do
  before { @ticket = Ticket.make(:name => 'New Ticket') }

  it { should belong_to :project }
  it { should have_many :work_units }
  it { should have_many :file_attachments }

  it { should validate_presence_of :project_id }
  it { should validate_presence_of :name }

  describe 'to ensure proper state transitioning' do
    before(:each) do
      @ticket = Ticket.make
    end

    it 'should start in "fridge"' do
      @ticket.state.should == "fridge"
    end

    it 'should change state from "fridge" to "development"' do
      @ticket.move_to_development
      @ticket.state.should == "development"
    end

    it 'should change state from "development" to "peer_review"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.state.should == "peer_review"
    end

    it 'should change state from "peer_review" to "development"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.move_to_development
      @ticket.state.should == "development"
    end

    it 'should change state from "peer review" to "user_acceptance"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.move_to_user_acceptance
      @ticket.state.should == "user_acceptance"
    end
    
    it 'should change state from "user_acceptance" to "archived"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.move_to_user_acceptance
      @ticket.move_to_archived
      @ticket.state.should == "archived"
    end

    it 'should change state from "user_acceptance" to "development"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.move_to_user_acceptance
      @ticket.move_to_development
      @ticket.state.should == "development"
    end
    
    it 'should not change state from "archived" to "development"' do
      @ticket.move_to_development
      @ticket.move_to_peer_review
      @ticket.move_to_user_acceptance
      @ticket.move_to_archived
      @ticket.move_to_development
      @ticket.state.should == "archived"
    end
    
    it 'should not skip states' do
      @ticket.move_to_peer_review.should == false
      @ticket.move_to_user_acceptance.should == false
      @ticket.move_to_archived.should == false
      @ticket.move_to_development
      @ticket.move_to_user_acceptance.should == false
      @ticket.move_to_archived.should == false
      @ticket.move_to_peer_review
      @ticket.move_to_archived.should == false
    end
  end
end
