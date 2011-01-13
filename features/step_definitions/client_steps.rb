Given /^the following clients:$/ do |clients|
  Client.create!(clients.hashes)
end

When /^I visit the clients index page$/ do
  visit clients_path
end

When /^I delete the (\d+)(?:st|nd|rd|th) client$/ do |pos|
  visit clients_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following clients:$/ do |expected_clients_table|
  expected_clients_table.diff!(tableish('table tr', 'td,th'))
end

Given /^the following clients, projects and tickets exist$/ do |table|
  table.hashes.each do |row|
    client  = Client.make :name => row["client name"]
    project = Project.make :name => row["project name"], :client => client
    ticket  = Ticket.make :name => row["ticket name"],   :project => project
    Client.find_by_name(client.name).should_not == nil
    client.projects.find_by_name(project.name).should_not == nil
    project.tickets.find_by_name(ticket.name).should_not == nil
  end
end
