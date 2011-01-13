Given /^the following contacts:$/ do |contacts|
  Contact.create!(contacts.hashes)
end

When /^I visit the contacts index page$/ do
  visit client_contacts_path
end



When /^I delete the (\d+)(?:st|nd|rd|th) contact$/ do |pos|
  visit client_contacts_path
  within("table tbody tr:nth-child(#{pos.to_i})") do
    click_link "Destroy"
  end
end

Then /^I should see the following contacts:$/ do |expected_contacts_table|
  expected_contacts_table.diff!(tableish('table tr', 'td,th'))
end


