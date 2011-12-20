GithubConcern::Engine.config do |gc|
  gc.user_lambda = lambda {|email| User.find_by_email email}
  gc.user_class  = User
end
