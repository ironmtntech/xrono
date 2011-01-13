Given /^I have (?:a|an) "([^\"]*)" work unit scheduled today for "([^\"]*)" hours$/ do |hours_type, hours|
  WorkUnit.make(:hours_type => hours_type, :scheduled_at => Date.current, :user => @current_user, :hours => hours)
end

Then /^I should see the following work_units:$/ do |expected_work_units_table|
  expected_work_units_table.diff!(tableish('table tr', 'td,th'))
end

When /^I create a work unit with #{capture_model}$/ do |ticket|
  WorkUnit.make(:ticket => find_model!(ticket))
end

Given /^I have no work units for the previous day$/ do
  @current_user.work_units.where(:scheduled_at => Date.yesterday).destroy_all
end

