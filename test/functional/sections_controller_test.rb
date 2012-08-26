require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @section = sections(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sections)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create section" do
    assert_difference('Section.count') do
      post :create, :section => { :course_id => @section.course_id, :professor_id => @section.professor_id, :rate_difficulty => @section.rate_difficulty, :rate_fun => @section.rate_fun, :rate_overall => @section.rate_overall, :rate_professor => @section.rate_professor, :rate_recommend => @section.rate_recommend }
    end

    assert_redirected_to section_path(assigns(:section))
  end

  test "should show section" do
    get :show, :id => @section
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @section
    assert_response :success
  end

  test "should update section" do
    put :update, :id => @section, :section => { :course_id => @section.course_id, :professor_id => @section.professor_id, :rate_difficulty => @section.rate_difficulty, :rate_fun => @section.rate_fun, :rate_overall => @section.rate_overall, :rate_professor => @section.rate_professor, :rate_recommend => @section.rate_recommend }
    assert_redirected_to section_path(assigns(:section))
  end

  test "should destroy section" do
    assert_difference('Section.count', -1) do
      delete :destroy, :id => @section
    end

    assert_redirected_to sections_path
  end
end
