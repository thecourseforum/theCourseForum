require 'spec_helper'
include Devise::TestHelpers 

describe ReviewsController do
  before(:each) do
    @user = User.find_by(:email => "example@email.com") ? 
            User.find_by(:email => "example@email.com") : 
            User.create(:email => "example@email.com", :password => "password", :password_confirmation => "password")
    @student = Student.find_or_create_by(grad_year: 2014, user_id: @user.id)
    @user.student = @student
    @review = Review.find_or_create_by(student_id: 1, professor_rating: 1.0, enjoyability: 1, 
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