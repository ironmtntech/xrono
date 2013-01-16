Plutus::Transaction.class_eval do

  def account
    if debit_amounts
      debit_amounts.first.account
    end
  end

  def is_a_debit?
    /Issue/.match(description) || /Deduct/.match(description)
  end

end
