When /^I search for '([^"]*)'$/ do |text|
  fill_in('search-query', :with => text)
  click_button('Search')
end

When /^I click on '([^"]*)'$/ do |text|
	click_link(text)
end
