When /^I search for '([^"]*)'$/ do |text|
  fill_in('search-query', :with => text)
  sleep 0.2
  within('.navbar-right') do
    find('search-query').native.send_key(:enter)
  end
end

When /^I click on Program and Data Representation$/ do
  execute_script("$('a:contains(\"Program and Data Representation\")').get(0).click();")
end
