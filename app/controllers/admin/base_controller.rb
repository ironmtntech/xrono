class Admin::BaseController < ApplicationController
  before_filter :require_admin
  helper :admin_base

  def index
  end

  def reports
  end
end
