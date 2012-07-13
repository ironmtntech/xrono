Given /^the following user records:$/ do |users|
  users.hashes.each do |user|
    the_role = user.delete("role")
    u = User.create(user)
    # add role
    u.has_role!(the_role.to_sym)
  end
end

Given /^the user "([^"]*)" has (?:a|an) "([^"]*)" role(?: on #{capture_model})?$/ do |email, role, model_name|
  if model_name
    User.find_by_email(email).has_role!(role.to_sym, find_model(model_name))
  else
    User.find_by_email(email).has_role!(role.to_sym)
  end
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit admin_users_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_button "Destroy"
  end
end

Then /^there should be a user with a client login in the database$/ do
  email = "client_login@user.com"
  User.find(:all, :conditions => ["email = ? AND client = ?", email, true]).any?.should == true
end

Given /^I am an authenticated client on an existing project page$/ do
  visit destroy_user_session_path
  current_user = User.make(:email => "current_user@example.com", :password => "password", :password_confirmation => "password")
  current_user.has_role!("client")
  c = Client.create(:name => "Test Client", :status => "Active")
  p = Project.create(:name => "Test Project", :client_id => c.id)
  current_user.has_role!(:client, p)
  visit new_user_session_path
  step %{I fill in "user_email" with "current_user@example.com"}
  step %{I fill in "user_password" with "password"}
  step %{I press "Sign in"}
  visit client_login_project_path(p)
end

