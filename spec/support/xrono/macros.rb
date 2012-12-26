module XronoTestHelper
  module Macros
    def authenticate_user!
      before(:each) do
        request.env['warden'].stub :authenticate! => user
        controller.stub :current_user => user
        user.ensure_authentication_token!
      end
    end
  end
end

RSpec.configure do |config|
  config.extend XronoTestHelper::Macros, :type => :controller
end
