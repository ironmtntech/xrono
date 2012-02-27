require 'spec_helper'

describe Api::V1::TokensController do
  describe "creating a token" do
    let(:user) { User.make(:password => 'testtest', :password_confirmation => 'testtest') }

    describe "when sent a valid email and password for a non client non admin" do
      it "generates a token" do
        response = post :create, :email => user.email, :password => "testtest"
        json_response = JSON.parse(response.body)
        json_response["success"].should be_true
        json_response["token"].should =~ /^.{20}$/
        json_response["admin"].should == false
        json_response["client"].should == false
        json_response["current_hours"].should == "0.0"
        json_response["pto_hours"].should == SiteSettings.first.total_yearly_pto_per_user.to_s
        json_response["offset"].should == "0.0"
      end
    end

    describe "when sent a valid email and password for an admin" do
      it "generates a token" do
        user.has_role!("admin")
        response = post :create, :email => user.email, :password => "testtest"
        json_response = JSON.parse(response.body)
        json_response["success"].should be_true
        json_response["token"].should =~ /^.{20}$/
        json_response["admin"].should == true
        json_response["client"].should == false
        json_response["current_hours"].should == "0.0"
        json_response["pto_hours"].should == SiteSettings.first.total_yearly_pto_per_user.to_s
        json_response["offset"].should == "0.0"
      end
    end

    describe "when sent an invalid password" do
      it "does not generate a token" do
        response = post :create, :email => user.email, :password => "testtest1"
        json_response = JSON.parse(response.body)
        json_response["success"].should be_false
      end
    end

    describe "when sent an invalid email" do
      it "does not generate a token" do
        response = post :create, :email => "#{user.email}t", :password => "testtest1"
        json_response = JSON.parse(response.body)
        json_response["success"].should be_false
      end
    end
  end
end
