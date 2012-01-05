class GithubTestController < ApplicationController
  skip_before_filter :authenticate_user!
  def payload
    gp = GitPush.create(:payload => JSON.parse(params["payload"]))
    render :nothing => true, :status => 200
  end
end
