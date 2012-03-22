When /^(?:|I )double[-\s]?click "([^"]*)"$/ do |locator|
  element = page.find_by_id('fridge_ul').find('li')
  page.driver.browser.mouse.double_click(element.native)
end

Given /^ticket "([^"]*)" has a work unit with description: "([^"]*)"$/ do |ticket_name, desc|
  ticket = Ticket.find_by_name ticket_name
  WorkUnit.create!(:hours_type => "Normal", :description => desc, :ticket_id => ticket.id, :hours => 8, :scheduled_at => "2010-10-01 12:00:00", :user_id => @current_user.id) 
end
