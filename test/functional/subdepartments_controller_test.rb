require 'test_helper'

class SubdepartmentsControllerTest < ActionController::TestCase
  setup do
    @subdepartment = subdepartments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:subdepartments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create subdepartment" do
    assert_difference('Subdepartment.count') do
      post :create, subdepartment: { mnemonic: @subdepartment.mnemonic, name: @subdepartment.name }
    end

    assert_redirected_to subdepartment_path(assigns(:subdepartment))
  end

  test "should show subdepartment" do
    get :show, id: @subdepartment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @subdepartment
    assert_response :success
  end

  test "should update subdepartment" do
    put :update, id: @subdepartment, subdepartment: { mnemonic: @subdepartment.mnemonic, name: @subdepartment.name }
    assert_redirected_to subdepartment_path(assigns(:subdepartment))
  end

  test "should destroy subdepartment" do
    assert_difference('Subdepartment.count', -1) do
      delete :destroy, id: @subdepartment
    end

    assert_redirected_to subdepartments_path
  end
end
