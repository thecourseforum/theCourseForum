require 'test_helper'

class GradesControllerTest < ActionController::TestCase
  setup do
    @grade = grades(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:grades)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create grade" do
    assert_difference('Grade.count') do
      post :create, grade: { count_a: @grade.count_a, count_aminus: @grade.count_aminus, count_b: @grade.count_b, count_bminus: @grade.count_bminus, count_bplus: @grade.count_bplus, count_c: @grade.count_c, count_cminus: @grade.count_cminus, count_cplus: @grade.count_cplus, count_d: @grade.count_d, count_dminus: @grade.count_dminus, count_dplus: @grade.count_dplus, count_drop: @grade.count_drop, count_f: @grade.count_f, count_other: @grade.count_other, count_withdraw: @grade.count_withdraw, gpa: @grade.gpa }
    end

    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should show grade" do
    get :show, id: @grade
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @grade
    assert_response :success
  end

  test "should update grade" do
    put :update, id: @grade, grade: { count_a: @grade.count_a, count_aminus: @grade.count_aminus, count_b: @grade.count_b, count_bminus: @grade.count_bminus, count_bplus: @grade.count_bplus, count_c: @grade.count_c, count_cminus: @grade.count_cminus, count_cplus: @grade.count_cplus, count_d: @grade.count_d, count_dminus: @grade.count_dminus, count_dplus: @grade.count_dplus, count_drop: @grade.count_drop, count_f: @grade.count_f, count_other: @grade.count_other, count_withdraw: @grade.count_withdraw, gpa: @grade.gpa }
    assert_redirected_to grade_path(assigns(:grade))
  end

  test "should destroy grade" do
    assert_difference('Grade.count', -1) do
      delete :destroy, id: @grade
    end

    assert_redirected_to grades_path
  end
end
