class DistributionManager

  def initialize options={}
    @transaction_class = options[:transaction_class] || Plutus::Transaction
  end

  # TODO: What do we call this account?
  def main_account_name
    'MAIN_ACCOUNT'
  end

  def short_day_account_name
    'SHORT_DAY_ACCOUNT'
  end

  def short_day_account
    Plutus::Asset.find_by_name short_day_account_name
  end

  def transfer_credits description, from_account, to_account, amount
    transaction = @transaction_class.build({
      description: description,
      debits:      [{ account: to_account, amount: amount }],
      credits:     [{ account: from_account,   amount: amount }]
    })
    transaction.save
  end

  # This is to account for shorter offset time with half days given for the
  # entire company
  def issue_hours_for_short_days amount
    transfer_credits "Issue Hours For Short Days", main_account_name, short_day_account_name, amount
  end

  def issue_per_diem_to_user user, amount
    transfer_credits "Issue Per Diem to User", main_account_name, user.per_diem_account_name, amount
  end

  def issue_demerit_fee_to_user user, amount
    transfer_credits "Issue Demerit Fee to User", main_account_name, user.demerit_account_name, amount
    user.demerits.create
  end

  def reverse_demerit_fee_for_user user, amount
    transfer_credits "Reverse Demerit Fee for User", user.demerit_account_name, main_account_name, amount
  end

  def issue_pto_to_user user, amount
    transfer_credits "Issue Pto to User", main_account_name, user.pto_account_name, amount
  end

  def issue_remote_day_to_user user, amount
    transfer_credits "Issue Remote Day to User", main_account_name, user.remote_day_account_name, amount
  end

  def redeem_remote_day_from_user user, amount
    transfer_credits "User Redeem Remote Day Deduct", user.remote_day_account_name, main_account_name, amount
  end

  def issue_time_to_offset user, amount
    transfer_credits "Issue Time to Offset", main_account_name, user.offset_account_name, amount
  end

  def deduct_time_from_offset user, amount
    transfer_credits "Deduct Time From Offset", user.offset_account_name, main_account_name, amount
  end

end
