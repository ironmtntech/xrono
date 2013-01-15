Plutus::Account.class_eval do
  def transactions
    transactions = []
    debit_transactions.each do |t|
      transactions.push(t)
    end
    credit_transactions.each do |t|
      transactions.push(t)
    end
    transactions
  rescue
    "n/a"
  end

  def last_transaction
    transactions.sort_by{|s| s.created_at }.last
  end

  def last_transaction_time
    created_at.strftime("%m/%d/%y")
  end

  def credited_today?
    last_transaction.created_at >= Date.today
  rescue
    false
  end
end
