Then /^I should see the following tickets:$/ do |expected_tickets_table|
  expected_tickets_table.diff!(find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } })
end

Then /^I should be able to create a new ticket$/ do
  step %{I follow "New Ticket"}
  step %{I fill in "Name" with "test"}
  step %{I fill in "Description" with "test description"}
  step %{I press "Create Ticket"}
  step %{I should see "Ticket created successfully"}
end

