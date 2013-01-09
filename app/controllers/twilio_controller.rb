class TwilioController < ApplicationController
  require 'twilio-ruby'

  def send_text
    @user = User.find(params[:id])
    if @user.phone
      @user.text!
      flash[:notice] = "Your message has been sent"
    else
      flash[:alert] = "You do not have a phone number listed"
    end
    redirect_to :back
  end

end
