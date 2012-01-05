class GithubTestController < ApplicationController
  skip_before_filter :authenticate_user!
  def payload
    gp = GitPush.create(:payload => JSON.parse(params["payload"]))
    Rails.logger.warn("***************************************************")
    Rails.logger.warn gp.valid?
    Rails.logger.warn gp.errors
    Rails.logger.warn "***************************************************"
    render :nothing => true, :status => 200
  end
end
