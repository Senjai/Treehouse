require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#new" do
    context "when not logged in" do
      should "be redirected to login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:jason)
      end

      should "get new page when logged in" do
        get :new
        assert_response :success
      end

      should "should set a flash error if the friend_id params is missing" do
        get :new, {}
        assert_equal "Friend Required", flash[:error]
      end

      should "display the friends name" do
        get :new, friend_id: users(:jim)
        assert_match /#{users(:jim).full_name}/, response.body
      end

      should "assign a new user friendship" do
        get :new, friend_id: users(:jim)
        assert assigns(:user_friendship)
      end

      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:jim)
        assert_equal users(:jim), assigns(:user_friendship).friend
      end

      should "assign a new user friendship to the currently logged in user" do
        get :new, friend_id: users(:jim)
        assert_equal users(:jason), assigns(:user_friendship).user
      end

      should "return 404 if no friend is found" do
        get :new, friend_id: 'invalid'
        assert_response :not_found
      end

      should "ask if you really want to request this friendship" do
        get :new, friend_id: users(:jim)
        assert_match /Do you really want to friend #{users(:jim).full_name}?/, response.body
      end
    end
  end

  context "#create" do
    context "when not logged in" do
      should "redirect to login page" do
        get :new
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:jason)
      end

      context "without friend id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert !flash[:error].empty?
        end

        should "redirect to root path" do
          assert_response :redirect
          assert_redirected_to root_path
        end
      end

      context "With a valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:mikethefrog) }
        end

        should "assign a friend object" do
          assert assigns(:friend)
          assert_equal users(:mikethefrog), assigns(:friend)
        end

        should "assign a user friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:mikethefrog), assigns(:user_friendship).friend
          assert_equal users(:jason), assigns(:user_friendship).user
        end

        should "create a friendship" do
          assert users(:jason).friends.include? users(:mikethefrog)
        end

        should "redirect to friends profile page" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mikethefrog))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "You are now friends with #{users(:mikethefrog).full_name}.", flash[:success]
        end

      end
    end
  end
end