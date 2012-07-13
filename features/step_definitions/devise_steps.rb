Given /^I am an authenticated user with an? (\w+) role$/ do |role|
  visit destroy_user_session_path
  @current_user = User.make(:email => "current_user@example.com", :password => "password", :password_confirmation => "password")
  @current_user.has_role!(role.to_sym) if role
  if role == 'client'
    p = Project.make
    @current_user.has_role!(:client, p)
  end
  visit new_user_session_path
  step %{I fill in "user_email" with "current_user@example.com"}
  step %{I fill in "user_password" with "password"}
  step %{I press "Sign in"}
end

Given /^I am an authenticated user$/ do
  visit destroy_user_session_path
  @current_user = User.make(:email => "current_user@example.com", :password => "password", :password_confirmation => "password")
  visit new_user_session_path
  step %{I fill in "user_email" with "current_user@example.com"}
  step %{I fill in "user_password" with "password"}
  step %{I press "Sign in"}
end

Then /^I should see the following users:$/ do |expected_users_table|
   expected_users_table.diff!(find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } })
end
