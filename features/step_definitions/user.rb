Given /^the link '([^"]*)'/ do |link|
  visit link
end

Given /^credentials '([^"]*)' '([^"]*)'/ do |user, password|
  @user = user
  @password = password
end

When /^I login ui$/ do
  within ('form[action="/users/sign_in"]') do
    fill_in('user_email', :with => @user)
    fill_in('user_password', :with => @password)
    click_button('Login')
  #sleep 2
  end
end

When /^I login ui without parameters$/ do
  click_button('Login')
end

# This is for regular user login, it has to have zone
When /^I login as '([^"]*)' to zone '([^"]*)'$/ do |user, zone|
  visit '/'
  @page = page
  fill_in('username', :with => user)
  fill_in('password', :with => Passcode[user])
  fill_in('zone_id', :with => zone)
  click_button('Login')
end