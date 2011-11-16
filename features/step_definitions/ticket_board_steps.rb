When /^I drag "([^"]*)" fridge ticket to "([^"]*)"$/ do |arg1, arg2|
  ticket = page.find_by_id('fridge_ul').find('li')
  development_bucket = page.find_by_id('development_ul')
  ticket.drag_to(development_bucket)
end

Then /^the ticket named "([^"]*)" should have a state of "([^"]*)"$/ do |ticket_name, state|
  ticket = Ticket.find_by_name ticket_name
  ticket.state.should == state
end

Then /^ticket "([^"]*)" should appear in "([^"]*)" bucket$/ do |ticket_name, bucket|
  ticket = page.find_by_id("#{bucket}_ul").find('li')  
end

When /^I drag "([^"]*)" development ticket to "([^"]*)"$/ do |arg1, arg2|
  ticket = page.find_by_id('development_ul').find('li')
  peer_review_bucket = page.find_by_id('peer_review_ul')
  ticket.drag_to(peer_review_bucket)
end

When /^I drag "([^"]*)" peer_review ticket to "([^"]*)"$/ do |arg1, arg2|
  ticket = page.find_by_id('peer_review_ul').find('li')
  user_acceptance_bucket = page.find_by_id('user_acceptance_ul')
  ticket.drag_to(user_acceptance_bucket)
end

When /^I drag "([^"]*)" user_acceptance ticket to "([^"]*)"$/ do |arg1, arg2|
  ticket = page.find_by_id('user_acceptance_ul').find('li')
  archived_bucket = page.find_by_id('archived_ul')
  ticket.drag_to(archived_bucket)
end

Then /^the ticket named "([^"]*)" in "([^"]*)" should have html id equal to ActiveRecord model id$/ do |ticket_name, bucket|
  ticket_AR = Ticket.find_by_name ticket_name
  ticket_HTML = page.find_by_id("#{bucket}_ul").find('li')
  ticket_HTML["id"].should == ticket_AR.id.to_s
end

