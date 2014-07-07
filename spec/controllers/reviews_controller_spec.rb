require 'spec_helper'
include Devise::TestHelpers 

describe ReviewsController do
  before(:each) do
    @user = User.find_by(:email => "example@virginia.edu") ? 
            User.find_by(:email => "example@virginia.edu") : 
            User.create(:email => "example@virginia.edu", :password => "password", :password_confirmation => "password")
    @student = Student.find_or_create_by(grad_year: 2014, user_id: @user.id)
    @user.student = @student

    @user2 = User.find_by(:email => "example2@virginia.edu") ? 
            User.find_by(:email => "example2@virginia.edu") : 
            User.create(:email => "example2@virginia.edu", :password => "password", :password_confirmation => "password")
    @student2 = Student.find_or_create_by(grad_year: 2014, user_id: @user2.id)
    @user2.student = @student2

    @review = Review.find_or_create_by(student_id: 2, professor_rating: 1.0, enjoyability: 1, 
                            difficulty: 1, recommend: 1, course_id: 1, professor_id: 1)
    @user.confirm!
    sign_in @user
  end

  describe "POST vote_up" do
    it "should add a positive vote" do
      post :vote_up, review_id: @review.id
      response.should be_success

      @user.reload
      @review.reload
      @user.votes.count.should be_equal(1)
      @review.votes_for.should be_equal(1)
      @review.votes_against.should be_equal(0)
    end
  end

  describe "POST vote_down" do
    it "should add a negative vote" do
      post :vote_down, review_id: @review.id
      response.should be_success

      @user.reload
      @review.reload
      @user.votes.count.should be_equal(1)
      @review.votes_for.should be_equal(0)
      @review.votes_against.should be_equal(1)
    end
  end
end