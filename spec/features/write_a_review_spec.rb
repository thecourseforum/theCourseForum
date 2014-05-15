require 'spec_helper'
include Devise::TestHelpers 

feature 'Writing a Review' do
  # before :each do
  #   @user = User.find_by(email: "example@virginia.edu") ? 
  #           User.find_by(email: "example@virginia.edu") : 
  #           User.create(email: "example@virginia.edu", password: "password", password_confirmation: "password")
  #   @user.confirm!
  # end

  # scenario 'Valid user writes a valid review' do
  #   @user = User.find_by(email: "example@virginia.edu") ? 
  #           User.find_by(email: "example@virginia.edu") : 
  #           User.create(email: "example@virginia.edu", password: "password", password_confirmation: "password")
  #   @user.confirm!

  #   visit root_path

  #   fill_in 'Email', with: @user.email
  #   fill_in 'Password', with: "password"

  #   click_button "Login"

  #   visit new_review_path

# TODO: Add class data for testing, and don't clean.

  #   sub_dept = Subdepartment.first
  #   course = sub_dept.courses.first
  #   prof = course.professors.first

  #   select sub_dept, from: "departments"

  #   select course, from: "courses"

  #   select prof, from: "professors"
  # end
end