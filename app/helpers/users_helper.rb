module UsersHelper

  def remote_day_available_for(acct)
    acct.name == current_user.remote_day_account.name && acct.balance > 0 && !current_user.has_pending_request?
  end

end
