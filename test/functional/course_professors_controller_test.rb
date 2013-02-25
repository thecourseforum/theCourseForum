require 'test_helper'

class CourseProfessorsControllerTest < ActionController::TestCase
  setup do
    @course_professor = course_professors(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:course_professors)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create course_professor" do
    assert_difference('CourseProfessor.count') do
      post :create, course_professor: {  }
    end

    assert_redirected_to course_professor_path(assigns(:course_professor))
  end

  test "should show course_professor" do
    get :show, id: @course_professor
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @course_professor
    assert_response :success
  end

  test "should update course_professor" do
    put :update, id: @course_professor, course_professor: {  }
    assert_redirected_to course_professor_path(assigns(:course_professor))
  end

  test "should destroy course_professor" do
    assert_difference('CourseProfessor.count', -1) do
      delete :destroy, id: @course_professor
    end

    assert_redirected_to course_professors_path
  end
end
