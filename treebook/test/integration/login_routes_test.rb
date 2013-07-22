require 'test_helper'

class LoginRoutesTest < ActionDispatch::IntegrationTest
  def test_that_sign_in_works
    get '/login'
    assert_response :success
  end

  def test_that_sign_up_works
    get '/logout'
    assert_response :redirect
  end
end
