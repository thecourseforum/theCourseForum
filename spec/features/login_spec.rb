require 'rails_helper'

feature 'Login' do
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

  scenario 'Confirmed user with student signs in and sees browse' do
    @user = create(:confirmed_user_with_student)

    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "password"

    click_button "Login"

    expect(page).to have_content("Browse")
  end
end