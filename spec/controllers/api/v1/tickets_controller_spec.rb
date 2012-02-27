require 'spec_helper'

describe Api::V1::TicketsController do

  let(:user) { User.make }
  let(:ticket) { Ticket.make }
  let(:ticket_2) { Ticket.make }

  authenticate_user!

  before(:each) do
    ticket.project.update_attribute(:git_repo_url, "test_2")
    ticket.update_attribute(:git_branch, "test_branch")

    ticket_2.project.update_attribute(:git_repo_url, "test")
    ticket_2.update_attribute(:git_branch, "test_branch")
  end

  describe "when I hit create" do
    describe "with a valid params" do
      it "creates that ticket" do
        response = post :create, :ticket => {:project_id => ticket.project.id, :name => "Test", :estimated_hours => "0", :description => "test"}, :auth_token => user.authentication_token
        JSON.parse(response.body)["success"].should == true
        Ticket.last.name.should == "Test"
      end
    end

    describe "with a valid params but no auth token" do
      it "creates that ticket" do
        response = post :create, :ticket => {:project_id => ticket.project.id, :name => "Chuck Testa", :estimated_hours => "0", :description => "Chuck Testa"}
        JSON.parse(response.body)["success"].should == false
      end
    end

    describe "with invalid params" do
      it "doesn't create that ticket" do
        response = post :create, :ticket => {:estimated_hours => "0", :project_id => ticket.project.id}
        JSON.parse(response.body)["success"].should == false
      end
    end
  end

  describe "when I hit show" do
    describe "without an auth token" do
      it "returns success false" do
        response = get :show, :id => ticket.id
        response.body.should == {:success => false}.to_json
      end
    end

    describe "with a valid id" do
      it "returns that ticket" do
        response = get :show, :id => ticket.id, :auth_token => user.authentication_token
        json_hash = ""
        json_hash = {
            :name                 => ticket.name,
            :estimated_hours      => ticket.estimated_hours,
            :percentage_complete  => ticket.percentage_complete,
            :hours                => ticket.hours
        }
        response.body.should == json_hash.to_json
      end
    end
  end
  describe "when I hit index" do
    describe "without an auth token" do
      it "returns success false" do
        response = get :index
        response.body.should == {:success => false}.to_json
      end
    end
    describe "without any parameters except auth token" do
      it "returns all tickets" do
        response = get :index, :auth_token => user.authentication_token
        json_array = []
        [ticket,ticket_2].sort_by(&:name).each do |t|
          json_hash = {
              :id                   => t.id,
              :name                 => t.name,
              :estimated_hours      => t.estimated_hours,
              :percentage_complete  => t.percentage_complete,
              :hours                => t.hours
          }
          json_array << json_hash
        end
        response.body.should == json_array.to_json
      end
    end
    describe "with some parameters" do
      describe "git_repo_url and branch" do
        it "returns all tickets from that project with git_repo_url and branch_name" do
          response = get :index, :repo_url => "test", :branch => "test_branch", :auth_token => user.authentication_token
          json_array = []
          json_hash = {
              :id                   => ticket_2.id,
              :name                 => ticket_2.name,
              :estimated_hours      => ticket_2.estimated_hours,
              :percentage_complete  => ticket_2.percentage_complete,
              :hours                => ticket_2.hours
          }
          json_array << json_hash
          response.body.should == json_array.to_json
        end
      end
      describe "project_id" do
        it "returns all tickets from that project" do
          response = get :index, :project_id => ticket.project_id, :auth_token => user.authentication_token
          json_array = []
          json_hash = {
              :id                   => ticket.id,
              :name                 => ticket.name,
              :estimated_hours      => ticket.estimated_hours,
              :percentage_complete  => ticket.percentage_complete,
              :hours                => ticket.hours
          }
          json_array << json_hash
          response.body.should == json_array.to_json
        end
      end
    end
  end
end
