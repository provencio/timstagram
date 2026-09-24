require 'test_helper'

class AuthPagesTest < ActionDispatch::IntegrationTest
  test 'the signed out pages render' do
    [new_user_session_path, new_user_registration_path, new_user_password_path].each do |path|
      get path
      assert_response :success, path
      assert_select '.auth .card form'
    end
  end
end
