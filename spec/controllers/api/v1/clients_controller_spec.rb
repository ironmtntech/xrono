require 'spec_helper'

describe Api::V1::ClientsController do

  let(:user) { User.make }
  let(:project) { Project.make }
  let(:project_2) { Project.make }

  authenticate_user!

  before(:each) do
    user.has_role!("developer", project)
    user.has_role!("developer", project_2)
  end

  describe "when I hit index" do
    describe "without the auth token" do
      it "returns success false" do
        response = get :index
        response.body.should == {:success => false}.to_json
      end
    end

    describe "without any parameters except the auth token" do
      it "returns all clients I have a role for" do
        response = get :index, :auth_token => user.authentication_token
        response.body.should == [project.client, project_2.client].sort{|a,b| a.name <=> b.name}.to_json
      end
    end

    describe "with initials" do
      it "returns all clients I have a role for that have the intials I sent" do
        response = get :index, :initials => project.client.initials, :auth_token => user.authentication_token
        response.body.should == [project.client].to_json
      end
    end
  end

end
