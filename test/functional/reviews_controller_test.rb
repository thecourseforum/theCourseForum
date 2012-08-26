require 'test_helper'

class ReviewsControllerTest < ActionController::TestCase
  setup do
    @review = reviews(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:reviews)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create review" do
    assert_difference('Review.count') do
      post :create, :review => { :post_date => @review.post_date, :rate_difficulty => @review.rate_difficulty, :rate_fun => @review.rate_fun, :rate_overall => @review.rate_overall, :rate_professor => @review.rate_professor, :rate_recommend => @review.rate_recommend, :section_id => @review.section_id, :user_id => @review.user_id }
    end

    assert_redirected_to review_path(assigns(:review))
  end

  test "should show review" do
    get :show, :id => @review
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @review
    assert_response :success
  end

  test "should update review" do
    put :update, :id => @review, :review => { :post_date => @review.post_date, :rate_difficulty => @review.rate_difficulty, :rate_fun => @review.rate_fun, :rate_overall => @review.rate_overall, :rate_professor => @review.rate_professor, :rate_recommend => @review.rate_recommend, :section_id => @review.section_id, :user_id => @review.user_id }
    assert_redirected_to review_path(assigns(:review))
  end

  test "should destroy review" do
    assert_difference('Review.count', -1) do
      delete :destroy, :id => @review
    end

    assert_redirected_to reviews_path
  end
end
