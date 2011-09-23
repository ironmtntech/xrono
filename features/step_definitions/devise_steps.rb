require 'ruby-debug'
Given /^I am an authenticated user(?: with an? (\w+) role)?$/ do |role|
  visit destroy_user_session_path
  @current_user = User.make(:email => "current_user@example.com", :password => "password", :password_confirmation => "password")
  @current_user.has_role!(role.to_sym) if role
  visit new_user_session_path
  And %{I fill in "user_email" with "current_user@example.com"}
  And %{I fill in "user_password" with "password"}
  And %{I press "Sign in"}
end

Then /^I should see the following users:$/ do |expected_users_table|
   expected_users_table.diff!(tableish('table tr', 'td,th'))
end
