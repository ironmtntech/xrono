class Admin::DemeritsController < ApplicationController

  def index
    @demerits = Demerit.unresolved
  end

  def remove
    demerit = Demerit.find(params[:demerit_id])
    user = User.find(params[:user_id])
    demerit.resolved = true
    if demerit.save
      DistributionManager.new.reverse_demerit_fee_for_user(user, 25)
      flash[:notice] = "The demerit was successfully reversed"
    else
      flash[:notice] = "There was a problem reversing the demerit, please try again."
    end
    redirect_to :back
  end

end
