require 'spec_helper'

describe Api::V1::ClientsController do

  before(:each) do
    @user = User.make
    request.env['warden'].stub :authenticate! => @user
    controller.stub :current_user => @user
    @user.ensure_authentication_token!
    @project = Project.make
    @project_1 = Project.make
    @user.has_role!("client", @project)
    @user.has_role!("developer", @project_1)
  end

  describe "when I hit index" do
    describe "without any parameters" do
      it "should return all clients I have a role for" do
        response = get :index, :auth_token => @user.authentication_token
        response.body.should == [@project.client, @project_1.client].sort{|a,b| a.name <=> b.name}.to_json
      end
    end

    describe "with initials" do
      it "should return all clients I have a role for that have the intials I sent" do
        response = get :index, :initials => @project.client.initials, :auth_token => @user.authentication_token
        response.body.should == [@project.client].to_json
      end
    end
  end

end
