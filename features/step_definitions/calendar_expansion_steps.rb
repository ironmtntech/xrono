Then /^I should see description$/ do 
  page.should have_css('.description')
end

Then /^I should see description\.expand$/ do
  page.should have_css('.description.expand')
end
