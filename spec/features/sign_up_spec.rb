require 'spec_helper'

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

    expect(find("#notice").text).to_not be_empty
    # Sign up should have sent an email to the user
    expect(ActionMailer::Base.deliveries.count).to be_equal mail_count + 1
    expect(User.count).to be_equal past_count + 1
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

    expect(find("#notice").text).to be_empty
    expect(ActionMailer::Base.deliveries.count).to be_equal mail_count
    expect(User.count).to be_equal past_count

    expect(page).to have_content("Please enter a first name.")
    expect(page).to have_content("Please enter a last name.")
    expect(page).to have_content("Please enter a valid UVa email.")
    expect(page).to have_content("Please enter a valid password (at least 8 characters).")
    expect(page).to have_content("Confirmation does not match password.")
  end

  scenario 'Confirmed user signs in and fills out student sign up' do
    @user = create(:confirmed_user_no_student)

    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "password"

    click_button "Login"

    expect(page).to have_content("Tell us more about yourself:")

    select Time.now.year, from: 'Graduation Year'

    click_button "Start using theCourseForum!"

    expect(page).to have_content("Browse")
  end
end