Given /^the user$/ do
  unless User.find_by(:email => 'aw3as@virginia.edu')
    FactoryGirl.create :student
  end
end

Given /^a user is logged in$/ do
  step 'the user'
  step 'the homepage'
  step "I login ui with 'aw3as@virginia.edu' 'password'"
end

When /^I login ui with '([^"]*)' '([^"]*)'/ do |user, password|
  within ('form[action="/users/sign_in"]') do
    fill_in('user_email', :with => user)
    fill_in('user_password', :with => password)
    step 'I login ui'
  end
end

When /^I login ui without parameters$/ do
  step 'I login ui'
end

When /^I login ui$/ do
  click_button('Login')
end

When /^I logout$/ do
  find('#user-account').click
  find('a[href="/users/sign_out"]').click
end

Then /^I should see notice: '([^"]*)'/ do |text|
  find('#notice', :text => text)
end

Then /^I should see Email and Password text fields$/ do
  within page.find('form[action="/users/sign_in"]') do
    find('#user_email')
    find('#user_password')
  end
end