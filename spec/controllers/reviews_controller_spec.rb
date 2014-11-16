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

  let(:valid_attributes) do
    {
      student_id: 1,
      professor_rating: 3,
      enjoyability: 3,
      difficulty: 3,
      recommend: 3,
    }
  end

  let(:valid_attributes_with_class) do
    {
      student_id: 1,
      professor_rating: 3,
      enjoyability: 3,
      difficulty: 3,
      recommend: 3,
      course_id: 1,
      professor_id: 1,
    }
  end

  let(:invalid_attributes) do
    {
      student_id: 1,
      professor_rating: 0,
      enjoyability: -1,
      difficulty: 0,
      recommend: 0.2,
    }
  end

  describe "GET new" do
    it "assigns a new review as @review" do
      get :new
      expect(assigns(:review)).to be_a_new(Review)
    end
  end

  describe "GET edit" do
    it "assigns the requested review as @review" do
      review = build(:review)
      user = create(:confirmed_user_with_student, email: "more_different@virginia.edu")
      review.user = user
      review.save
      get :edit, {:id => review.to_param}
      expect(assigns(:review)).to eq(review)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Review and redirects to correct course_professors page" do
        expect {
          post :create, {:review => valid_attributes, course_select: Review.count+1, prof_select: Review.count+1}
        }.to change(Review, :count).by(1)
        expect(response).to redirect_to(course_professors_path(c: Review.count, p: Review.count))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved review as @review" do
        post :create, {:review => invalid_attributes, course_select: Review.count+1, prof_select: Review.count+1}
        expect(assigns(:review)).to be_a_new(Review)
      end

      it "re-renders the 'new' template" do
        post :create, {:review => invalid_attributes, course_select: Review.count+1, prof_select: Review.count+1}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested review" do
        review = Review.create! valid_attributes_with_class
        put :update, {:id => review.to_param, :review => new_attributes}
        review.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested review as @review" do
        review = Review.create! valid_attributes_with_class
        put :update, {:id => review.to_param, :review => valid_attributes}
        expect(assigns(:review)).to eq(review)
      end

      it "redirects to my reviews page" do
        review = Review.create! valid_attributes_with_class
        put :update, {:id => review.to_param, :review => valid_attributes}
        expect(response).to redirect_to(my_reviews_path)
      end
    end

    describe "with invalid params" do
      it "assigns the review as @review" do
        review = Review.create! valid_attributes_with_class
        put :update, {:id => review.to_param, :review => invalid_attributes}
        expect(assigns(:review)).to eq(review)
      end

      it "re-renders the 'edit' template" do
        review = Review.create! valid_attributes_with_class
        put :update, {:id => review.to_param, :review => invalid_attributes}
        expect(@review.enjoyability).to be > 0
        expect(response).to redirect_to(edit_review_path(review))
        expect(response).to render_template("edit")
      end
    end
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
