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

Then /^I should see email and password text fields/ do
  within ('form[action="/users/sign_in"]') do
    find('#user_email')
    find('#user_password')
  end
  # find('.user_password', :placeholder => bar)
end

Then /^I should see notice: '([^"]*)'/ do |notice|
  find('#notice', :text => notice)
  # find('.user_password', :placeholder => bar)
end