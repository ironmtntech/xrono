Given /^I have (?:a|an) "([^\"]*)" work unit scheduled today for "([^\"]*)" hours$/ do |hours_type, hours|
  WorkUnit.make(:hours_type => hours_type, :scheduled_at => Date.current, :user => @current_user, :hours => hours)
end

Then /^I should see the following work_units:$/ do |expected_work_units_table|
  expected_work_units_table.diff!(find('table').all('tr').map { |row| row.all('th, td').map { |cell| cell.text.strip } })
end

When /^I create a work unit with #{capture_model}$/ do |ticket|
  WorkUnit.make(:ticket => find_model!(ticket))
end

Given /^I have no work units for the previous day$/ do
  @current_user.work_units.where(:scheduled_at => Date.yesterday).destroy_all
end

Given /^I have a "([^"]*)" hour work unit for yesterday with ticket "([^"]*)"$/ do |hours, ticket|
  WorkUnit.make(:ticket => find_model!(ticket), :hours_type => "Normal", 
    :scheduled_at => 1.days.ago.beginning_of_day, :user => @current_user, :hours => hours)
end

Then /^that work unit should still have a scheduled at date of yesterday$/ do
  WorkUnit.last.scheduled_at.should == 1.day.ago.beginning_of_day
end

Then /^I should see the new ticket fields$/ do
  within("#on_demand_ticket") do
    page.should have_css('#on_demand_ticket_name')
    page.should have_css('#on_demand_ticket_description')
    page.should have_css('#on_demand_ticket_estimated_hours')
  end
end

Then /^there should be a ticket named "([^"]*)" with (\d+) hours$/ do |ticket_name, hours|
  sleep(1)
  @ticket = Ticket.where(:name => ticket_name).last
  @ticket.should_not be_nil
  @ticket.work_units.last.hours.should == BigDecimal(hours)
end
