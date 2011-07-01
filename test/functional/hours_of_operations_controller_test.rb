require 'test_helper'

class HoursOfOperationsControllerTest < ActionController::TestCase
  setup do
    @hours_of_operation = hours_of_operations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:hours_of_operations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create hours_of_operation" do
    assert_difference('HoursOfOperation.count') do
      post :create, :hours_of_operation => @hours_of_operation.attributes
    end

    assert_redirected_to hours_of_operation_path(assigns(:hours_of_operation))
  end

  test "should show hours_of_operation" do
    get :show, :id => @hours_of_operation.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @hours_of_operation.to_param
    assert_response :success
  end

  test "should update hours_of_operation" do
    put :update, :id => @hours_of_operation.to_param, :hours_of_operation => @hours_of_operation.attributes
    assert_redirected_to hours_of_operation_path(assigns(:hours_of_operation))
  end

  test "should destroy hours_of_operation" do
    assert_difference('HoursOfOperation.count', -1) do
      delete :destroy, :id => @hours_of_operation.to_param
    end

    assert_redirected_to hours_of_operations_path
  end
end
