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

When /^I click on Browse by Professor$/ do
  click_button('Browse by Professor')
end

Then /^I should see First Letter of Professorss Last Name and a dropdown option/ do
  find('p',:text => 'First Letter of Professor')
end

When/^I click on Abramenko, Monika$/ do
  click_link("a[href=/professors/106]")
end

Then /^ I should see the courses APMA 1110, APMA 3080, APMA 8897, & MATH 1140/ do
  find('course_professors?c=203&p=106>')
  find('course_professors?c=206&p=106>')
  find('course_professors?c=222&p=106>')
  find('course_professors?c=4416&p=106>')
end





  