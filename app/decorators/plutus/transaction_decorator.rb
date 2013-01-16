Plutus::Transaction.class_eval do
  def is_a_debit?
    /Demerit/.match(description) || /Deduct/.match(description)
  end
end
