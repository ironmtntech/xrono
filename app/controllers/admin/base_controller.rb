class Admin::BaseController < ApplicationController
  before_filter :require_admin

  def index
  end

  def reports
  end

end
