require 'spec_helper'

describe Api::V1::TicketsController do

  before(:each) do
    @user = User.make
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
    @ticket = Ticket.make
    @ticket.project.update_attribute(:git_repo_url, "test_2")
    @ticket.update_attribute(:git_branch, "test_branch")

    @ticket_1 = Ticket.make
    @ticket_1.project.update_attribute(:git_repo_url, "test")
    @ticket_1.update_attribute(:git_branch, "test_branch")
  end

  describe "when I hit create" do
    describe "with a valid params" do
      it "should create that ticket" do
        response = post :create, :ticket => {:project_id => @ticket.project.id, :name => "Test", :estimated_hours => "0", :description => "test"}
        JSON.parse(response.body)["success"].should == true
        Ticket.last.name.should == "Test"
      end
    end
    describe "with invalid params" do
      it "should not create that ticket" do
        response = post :create, :ticket => {:estimated_hours => "0", :project_id => @ticket.project.id}
        JSON.parse(response.body)["success"].should == false
      end
    end
  end

  describe "when I hit show" do
    describe "with a valid id" do
      it "should return that ticket" do
        response = get :show, :id => @ticket.id
        json_hash = ""
        [@ticket].sort{|a,b| a.name <=> b.name}.each do |ticket|
          json_hash = {
              :name                 => ticket.name,
              :estimated_hours      => ticket.estimated_hours,
              :percentage_complete  => ticket.percentage_complete,
              :hours                => ticket.hours
          }
        end
        response.body.should == json_hash.to_json
      end
    end
  end
  describe "when I hit index" do
    describe "without any parameters" do
      it "should return all tickets" do
        response = get :index
        json_array = []
        [@ticket,@ticket_1].sort{|a,b| a.name <=> b.name}.each do |ticket|
          json_hash = {
              :id                   => ticket.id,
              :name                 => ticket.name,
              :estimated_hours      => ticket.estimated_hours,
              :percentage_complete  => ticket.percentage_complete,
              :hours                => ticket.hours
          }
          json_array << json_hash
        end
        response.body.should == json_array.to_json
      end
    end
    describe "with some parameters" do
      describe "git_repo_url and branch" do
        it "should return all tickets from that project with git_repo_url and branch_name" do
          response = get :index, :repo_url => "test", :branch => "test_branch"
          json_array = []
          [@ticket_1].sort{|a,b| a.name <=> b.name}.each do |ticket|
            json_hash = {
                :id                   => ticket.id,
                :name                 => ticket.name,
                :estimated_hours      => ticket.estimated_hours,
                :percentage_complete  => ticket.percentage_complete,
                :hours                => ticket.hours
            }
            json_array << json_hash
          end
          response.body.should == json_array.to_json
        end
      end
      describe "project_id" do
        it "should return all tickets from that project" do
          response = get :index, :project_id => @ticket.project_id
          json_array = []
          [@ticket].sort{|a,b| a.name <=> b.name}.each do |ticket|
            json_hash = {
                :id                   => ticket.id,
                :name                 => ticket.name,
                :estimated_hours      => ticket.estimated_hours,
                :percentage_complete  => ticket.percentage_complete,
                :hours                => ticket.hours
            }
            json_array << json_hash
          end
          response.body.should == json_array.to_json
        end
      end
    end
  end
end
