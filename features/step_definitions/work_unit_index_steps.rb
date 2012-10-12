Then /^I click on the tab Work units$/ do
  click_on('Work Units')
end

Then /^I should see a list of work units from that project$/ do
  page.find_link('All Work Units')
end

