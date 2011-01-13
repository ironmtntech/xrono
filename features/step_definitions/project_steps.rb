Given /^I am assigned to the project$/ do
  User.last.has_role!(:developer, Project.last)
end

Given /^the following projects:$/ do |projects|
  client = Client.create(:name => 'test', :status => 'test')
  projects.hashes.each do |hash|
    Project.create(hash.merge(:client_id => client.id))
  end
end

When /^I visit the projects index page for a given client$/ do
  client = Client.create(:name => 'test', :status => 'test')
  visit projects_path
end

When /^(?:|I )visit the new project page for a given client$/ do
  client = Client.create(:name => 'test', :status => 'test')
  visit new_client_project_path(client)
end

When /^I delete the (\d+)(?:st|nd|rd|th) project$/ do |pos|
  visit projects_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following projects:$/ do |expected_projects_table|
  expected_projects_table.diff!(tableish('table tr', 'td,th'))
end

