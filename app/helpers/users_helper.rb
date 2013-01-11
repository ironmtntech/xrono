module UsersHelper
  # evaluates whether a transaction positively or negatively affects a user
  # expects a Plutus::Transaction object passed in
  # returns true or false
  def is_a_debit?(transaction)
    /Demerit/.match(transaction.description) || /Deduct/.match(transaction.description)
  end
end
