Then /^I should see description$/ do 
  save_and_open_page
  page.should have_css('.description')
end

Then /^I should see description\.expand$/ do
  page.should have_css('.description.expand')
end
