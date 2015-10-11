When /^I click the link '([^"]*)'$/ do |text|
  find('a', :text => text).click
end