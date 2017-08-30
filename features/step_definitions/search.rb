When /^I search for '([^"]*)'$/ do |text|
  fill_in('search-query', :with => text)
  sleep 0.2
  find('#search-query').native.send_key(:enter)
end

When /^I click on Program and Data Representation$/ do
  execute_script("$('a:contains(\"Program and Data Representation\")').get(0).click();")
end
