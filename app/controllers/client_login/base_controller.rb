class ClientLogin::BaseController < ApplicationController
  skip_before_filter :redirect_clients
end
