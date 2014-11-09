require 'spec_helper'

feature 'Writing a Review' do
  before :each do
    @user = create(:confirmed_user_with_student)
  end

  scenario 'Valid user writes a valid review' do
    visit root_path

    fill_in 'Email', with: @user.email
    fill_in 'Password', with: "password"

    click_button "Login"

    visit new_review_path

    skip "Need to finish this test"
  end

# TODO: Add class data for testing, and don't clean.

  #   sub_dept = Subdepartment.first
  #   course = sub_dept.courses.first
  #   prof = course.professors.first

  #   select sub_dept, from: "departments"

  #   select course, from: "courses"

  #   select prof, from: "professors"
  # end
end