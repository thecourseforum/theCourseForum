require 'spec_helper'

feature 'Viewing a Review' do

  before :each do 
    # pending "FIX SIGN UP"
    Subdepartment.create(name: "Computer Science", mnemonic: "CS")
    Course.create(title: "Intro to Programming", course_number: "1110", subdepartment_id: 1)
    Professor.create(first_name: "Mark", last_name: "Sherriff")
    @review = Review.create(comment: "This is the worst.", course_id: 1, professor_id: 1)

    @user = create(:confirmed_user_with_student)
    sign_in_user @user
  end

  scenario 'Viewing correct review' do
    visit 'course_professors?c=1&p=1'

    expect(page).to have_content("Intro to Programming")

  end


end