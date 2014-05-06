require 'spec_helper'
include Devise::TestHelpers 

feature 'Sign Up' do
  scenario 'user fills out the sign up form correctly' do
    visit root_path

    past_count = User.count
    mail_count = ActionMailer::Base.deliveries.count

    fill_in 'First Name', with: 'John'
    fill_in 'Last Name', with: 'Smith'
    fill_in 'UVa Email Address', with: 'foobar@virginia.edu'
    fill_in 'user_password', with: 'password'
    fill_in 'user_password_confirmation', with: 'password'
    click_button 'Sign Up!'

    find("#notice").text.should_not be_empty
    # Sign up should have sent an email to the user
    ActionMailer::Base.deliveries.count.should be_equal mail_count + 1
    User.count.should be_equal past_count + 1
  end

  scenario 'user fills out the sign up form incorrectly', js: true do
    visit root_path

    past_count = User.count
    mail_count = ActionMailer::Base.deliveries.count

    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    fill_in 'UVa Email Address', with: 'foobar@notavirginiaemail.edu'
    fill_in 'user_password', with: 'not8'
    fill_in 'user_password_confirmation', with: 'fail'
    click_button 'Sign Up!'

    find("#notice").text.should be_empty
    ActionMailer::Base.deliveries.count.should be_equal mail_count
    User.count.should be_equal past_count

    expect(page).to have_content("Please enter a first name.")
    expect(page).to have_content("Please enter a last name.")
    expect(page).to have_content("Please enter a valid UVa email.")
    expect(page).to have_content("Please enter a valid password (at least 8 characters).")
    expect(page).to have_content("Confirmation does not match password.")
  end

  scenario 'Confirmed user signs in and sees student sign up page' do
    @user = User.find_by(email: "example@virginia.edu") ? 
            User.find_by(email: "example@virginia.edu") : 
            User.create(email: "example@virginia.edu", password: "password", password_confirmation: "password")
    @user.confirm!

    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "password"

    click_button "Login"

    expect(page).to have_content("Tell us more about yourself:")
  end
end