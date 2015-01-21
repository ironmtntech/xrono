module XronoTestHelper
  module Macros
    def authenticate_user!
      #before(:each) do
        #I added this based on that guide
        request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in user
      #end
    end
  end
end

RSpec.configure do |config|
  config.extend XronoTestHelper::Macros, :type => :controller
end
