class Admin::RemoteWorkdayRequestsController < ApplicationController

  def index
    if params[:view] == "approved"
      @requests = RemoteWorkdayRequest.approved.reverse
    elsif params[:view] == "denied"
      @requests = RemoteWorkdayRequest.denied.reverse
    else
      @requests = RemoteWorkdayRequest.pending.reverse
    end
  end

  def approve
    @request = RemoteWorkdayRequest.find(params[:id])
    @request.description = params[:desc]
    if @request.save
      @request.approve!
      flash[:notice] = "The remote workday request was successfully approved"
    else
      flash[:error] = "There was an error approving this remote workday request"
    end
    redirect_to admin_remote_workday_requests_path
  end

  def deny
    @request = RemoteWorkdayRequest.find(params[:id])
    @request.description = params[:desc]
    if @request.save
      @request.deny!
      flash[:notice] = "The remote workday request was successfully denied"
    else
      flash[:error] = "There was an error denying this remote workday request"
    end
    redirect_to admin_remote_workday_requests_path
  end

end
