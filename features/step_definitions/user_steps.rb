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

Given /^I am an authenticated user "([^"]*)" and password "([^"]*)"$/ do |email, password|
  User.make(:email => "dev@xrono.org")
  visit new_user_session_path
  fill_in("user_email", :with => email)
  fill_in("user_password", :with => password)
  click_button "Sign in"
end
