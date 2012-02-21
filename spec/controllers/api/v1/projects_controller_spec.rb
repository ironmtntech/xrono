require 'spec_helper'

describe Api::V1::ProjectsController do

  before(:each) do
    @user = User.make
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
    @project = Project.make
    @project_2 = Project.make
    @project_3 = Project.make
    @user.ensure_authentication_token!
    @user.has_role!("developer", @project)
    @user.has_role!("developer", @project_2)
  end

  describe "when getting index as a non admin" do
    describe "with no auth token" do
      it "should return success false" do
        response = get :index
        response.body.should == {:success => false}.to_json
      end
    end

    it "should return all @projects that you have a role for" do
      response = get :index, :auth_token => @user.authentication_token
      response.body.should == [@project_2,@project].sort{|a,b| a.name <=> b.name}.to_json
    end

    it "should filter by client_id" do
      response = get :index, :auth_token => @user.authentication_token, :client_id => @project_2.client.id
      response.body.should == [@project_2].to_json
    end

    it "should filter by client initials" do
      response = get :index, :auth_token => @user.authentication_token, :client_initials => @project_2.client.initials
      response.body.should == [@project_2].to_json
    end

    it "should filter by git repo url" do
      @project_2.update_attribute(:git_repo_url, "test")
      response = get :index, :auth_token => @user.authentication_token, :git_repo_url => "test"
      response.body.should == [@project_2].to_json
      @project_2.update_attribute(:git_repo_url, nil)
    end
  end

  describe "when getting index as an admin" do
    it "should return all @projects that you have a role for" do
      @user.has_role!("admin")
      response = get :index, :auth_token => @user.authentication_token
      response.body.should == [@project_3,@project,@project_2].sort{|a,b| a.name <=> b.name}.to_json
    end
  end
end
