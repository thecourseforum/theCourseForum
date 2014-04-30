require 'spec_helper'

feature 'User signs up for an account' do
  scenario 'they fill out the sign up form' do
    visit root_path

    past_count = User.count

    fill_in 'First Name', with: 'John'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'UVa Email Address', with: 'foobar@virginia.edu'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign Up!'

    find("#notice").text.should_not be_empty
    # Sign up should have sent an email to the user
    ActionMailer::Base.deliveries.should_not be_empty
    User.count.should_not be_equal past_count
    User.count.should be_equal past_count + 1
  end
end