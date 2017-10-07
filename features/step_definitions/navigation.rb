Given /^the homepage$/ do
  visit root_path
end

When /^I click on the dropdown$/ do
  find('.dropdown').click
end

When /^I click the link '([^"]*)'$/ do |text|
  first('a').click_link(text)
end

Then /^I should see '([^"]*)'$/ do |text|
  expect(page).to have_content(text, wait: 5)
end

When /^I wait a little$/ do
  sleep 5
end