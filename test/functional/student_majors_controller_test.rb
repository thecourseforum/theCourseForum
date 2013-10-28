require 'test_helper'

class StudentMajorsControllerTest < ActionController::TestCase
  setup do
    @student_major = student_majors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:student_majors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create student_major" do
    assert_difference('StudentMajor.count') do
      post :create, student_major: {  }
    end

    assert_redirected_to student_major_path(assigns(:student_major))
  end

  test "should show student_major" do
    get :show, id: @student_major
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @student_major
    assert_response :success
  end

  test "should update student_major" do
    put :update, id: @student_major, student_major: {  }
    assert_redirected_to student_major_path(assigns(:student_major))
  end

  test "should destroy student_major" do
    assert_difference('StudentMajor.count', -1) do
      delete :destroy, id: @student_major
    end

    assert_redirected_to student_majors_path
  end
end
