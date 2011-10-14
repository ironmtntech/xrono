Then /^the "([^"]*)" field(?: under (.*))? should hold "([^"]*)"$/ do |field, parent, value|
  with_scope(parent) do
    field = find_field(field)
    field_value = (field.tag_name == 'textarea') ? field.text : field.value
    if field_value.respond_to? :should
      field_value.should =~ /#{value.to_f}/
    else
      assert_match(/#{value.to_f}/, field_value)
    end
  end
end

Then /^"([^"]*)" should be seen within "([^"]*)"$/ do |value, field|
  assert page.has_xpath?("//option[contains(string(), '#{value}')]") 
end

Then /^"([^\"]+)" should not be visible$/ do |text|
  paths = [
    "//*[@class='hidden']/*[contains(.,'#{text}')]",
    "//*[@class='invisible']/*[contains(.,'#{text}')]",
    "//*[@style='display: none;']/*[contains(.,'#{text}')]"
  ]
  xpath = paths.join '|'
  page.should have_xpath(xpath)
end
