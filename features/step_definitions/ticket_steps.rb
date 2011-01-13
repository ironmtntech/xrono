Then /^I should see the following tickets:$/ do |expected_tickets_table|
  expected_tickets_table.diff!(tableish('table tr', 'td,th'))
end
