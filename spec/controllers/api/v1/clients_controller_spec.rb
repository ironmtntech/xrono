require 'spec_helper'

describe Api::V1::ClientsController do
  include RSpec::Rails::ControllerExampleGroup
  include Devise::TestHelpers
  let(:user) { User.make }
  let(:client)    { Client.make initials: 'FC1' }
  let(:client_2)  { Client.make initials: 'FC2' }
  let(:project)   { Project.make client: client }
  let(:project_2) { Project.make client: client_2 }

  before(:each) do
    user.has_role!("developer", project)
    user.has_role!("developer", project_2)
  end
  describe "when I hit index" do
=begin
    describe "without the auth token" do
      it "returns success false" do
        response = get :index
        expect(response.body).to eq({:success => false}.to_json)
      end
    end
=end
    describe "without any parameters except the auth token" do
      it "returns all clients I have a role for" do
        #after this gets called response.body is still returning {:success =>
        #false}
        #it isn't acting like it is logged in.  These were already existing test
        #and I'm changing them to work with the new versions of all the gems
        #binding.pry
        authenticate_user!
        get :index
        expect(response.body).to eq([project.client, project_2.client].sort{|a,b| a.name <=> b.name}.to_json)
      end
    end
=begin
    describe "with initials" do
      it "returns all clients I have a role for that have the intials I sent" do
        sign_in user
        get :index
        expect(response.body).to be([client].to_json)
      end
    end
=end
  end

end
