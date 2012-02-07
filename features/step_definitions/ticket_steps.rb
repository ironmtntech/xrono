Then /^I should see the following tickets:$/ do |expected_tickets_table|
  expected_tickets_table.diff!(find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } })
end
