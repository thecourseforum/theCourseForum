require 'rails_helper'

RSpec.describe ReviewsController, :type => :controller do

  before(:each) do
    @user = create(:confirmed_user_with_student)
    @different_user = create(:confirmed_user_with_student, email: "different@virginia.edu")
    @review = build(:review)
    @review.user = @different_user
    @review.save
    sign_in @user
  end

  describe "POST vote_up" do
    it "should add a positive vote" do
      post :vote_up, review_id: @review.id
      expect(response).to be_success

      @user.reload
      @review.reload
      expect(@user.votes.count).to be_equal(1)
      expect(@review.votes_for).to be_equal(1)
      expect(@review.votes_against).to be_equal(0)
    end
  end

  describe "POST vote_down" do
    it "should add a negative vote" do
      post :vote_down, review_id: @review.id
      expect(response).to be_success

      @user.reload
      @review.reload
      expect(@user.votes.count).to be_equal(1)
      expect(@review.votes_for).to be_equal(0)
      expect(@review.votes_against).to be_equal(1)
    end
  end

end
