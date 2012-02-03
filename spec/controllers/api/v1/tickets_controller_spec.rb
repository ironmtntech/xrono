require 'spec_helper'

describe Api::V1::TicketsController do

  before(:each) do
    @user = User.make
    @user.ensure_authentication_token!
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
    @ticket = Ticket.make
    @ticket.project.update_attribute(:git_repo_url, "test_2")
    @ticket.update_attribute(:git_branch, "test_branch")

    @ticket_1 = Ticket.make
    @ticket_1.project.update_attribute(:git_repo_url, "test")
    @ticket_1.update_attribute(:git_branch, "test_branch")
  end

  describe "when I hit show" do
    describe "without an auth token" do
      it "should return success false" do
        response = get :show, :id => @ticket.id
        response.body.should == {:success => false}.to_json
      end
    end

    describe "with a valid id" do
      it "should return that ticket" do
        response = get :show, :id => @ticket.id, :auth_token => @user.authentication_token
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
    describe "without an auth token" do
      it "should return success false" do
        response = get :index
        response.body.should == {:success => false}.to_json
      end
    end
    describe "without any parameters except auth token" do
      it "should return all tickets" do
        response = get :index, :auth_token => @user.authentication_token
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
          response = get :index, :repo_url => "test", :branch => "test_branch", :auth_token => @user.authentication_token
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
          response = get :index, :project_id => @ticket.project_id, :auth_token => @user.authentication_token
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
