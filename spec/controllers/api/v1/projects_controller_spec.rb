require 'spec_helper'

describe Api::V1::ProjectsController do

  let(:user) { User.make }
  let(:project) { Project.make }
  let(:project_2) { Project.make }

  authenticate_user!

  before(:each) do
    user.has_role!("developer", project)
    user.has_role!("developer", project_2)
  end

  describe "when getting index as a non admin" do
    describe "with no auth token" do
      it "returns success false" do
        response = get :index
        response.body.should == {:success => false}.to_json
      end
    end

    it "returns all projects that you have a role for" do
      response = get :index, :auth_token => user.authentication_token
      response.body.should == [project_2,project].sort_by(&:name).to_json
    end

    it "filters by client_id" do
      response = get :index, :auth_token => user.authentication_token, :client_id => project_2.client.id
      response.body.should == [project_2].to_json
    end

    it "filters by client initials" do
      response = get :index, :auth_token => user.authentication_token, :client_initials => project_2.client.initials
      response.body.should == [project_2].to_json
    end

    it "filters by git repo url" do
      project_2.update_attribute(:git_repo_url, "test")
      response = get :index, :auth_token => user.authentication_token, :git_repo_url => "test"
      response.body.should == [project_2].to_json
      project_2.update_attribute(:git_repo_url, nil)
    end
  end

  describe "when getting index as an admin" do
    let!(:project_3) { Project.make }
    it "returns all projects that you have a role for" do
      user.has_role!("admin")
      response = get :index, :auth_token => user.authentication_token
      response.body.should == [project_3,project,project_2].sort_by(&:name).to_json
    end
  end
end
