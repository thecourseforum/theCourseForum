When /^I search for '([^"]*)'$/ do |text|
  fill_in('search-query', :with => text)
  sleep 0.2
  within('.submit-row') do
    find('input').click
  end
end

When /^I click on Program and Data Representation$/ do
  execute_script("$('a:contains(\"Program and Data Representation\")').get(0).click();")
end
