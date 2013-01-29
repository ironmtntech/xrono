Plutus::Transaction.class_eval do

  def account
    if debit_amounts
      debit_amounts.first.account
    end
  end

  def is_a_credit?
    debit_accounts.select{|s| s.name == "MAIN_ACCOUNT" }.present?
  end

end
