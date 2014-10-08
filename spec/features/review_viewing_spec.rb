require 'spec_helper'
require 'support/devise_helper'
include Warden::Test::Helpers
Warden.test_mode!

feature 'Viewing a Review' do
  before :each do 
    # pending "FIX SIGN UP"
    Subdepartment.create(name: "Computer Science", mnemonic: "CS")
    Course.create(title: "Intro to Programming", course_number: "1110", subdepartment_id: 1)
    Professor.create(first_name: "Mark", last_name: "Sherriff")
    @review = Review.create(comment: "This is the worst.", course_id: 1, professor_id: 1)

    @user = User.find_by(email: "example@virginia.edu") ? 
            User.find_by(email: "example@virginia.edu") : 
            User.create(email: "example@virginia.edu", password: "password", password_confirmation: "password")

    Student.create(user_id: 1, grad_year: 2014)
    sign_in(@user)
  end

  scenario 'Viewing correct review' do
    visit 'course_professors?c=1&p=1'

    expect(page).to have_content("Intro to Programming")

  end


end