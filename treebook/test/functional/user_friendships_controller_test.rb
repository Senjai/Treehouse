require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase
  context "#index" do
    context "when not logged in" do
      should "be redirected to login page" do
        get :index
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @friendship1 = create(:pending_user_friendship, user: users(:jason), friend: create(:user, first_name: 'Pending',                                                                                         last_name: 'Friend'))
        @friendship2 = create(:accepted_user_friendship, user: users(:jason), friend: create(:user, first_name: 'Active',                                                                                         last_name: 'Friend'))

        sign_in users(:jason)
        get :index
      end

      should "get index page without error" do
        assert_response :success
      end

      should "assign user friendships" do
        assert assigns(:user_friendships)
      end

      should "display friends names" do
        assert_match /Pending/, response.body
        assert_match /Active/, response.body
      end

      should "display pending information on a pending friendship" do
        assert_select "#user_friendship_#{@friendship1.id}" do
          assert_select "em", "Friendship Pending."
        end
      end

      should "display accepted information on a accepted friendship" do
        assert_select "#user_friendship_#{@friendship2.id}" do
          assert_select "em", "Friendship Started."
        end
      end
    end
  end

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

      context "successfully" do
        should "create two user friendship objects" do
          assert_difference "UserFriendship.count", 2 do
            post :create, user_friendship: { friend_id: users(:mikethefrog).profile_name }
          end
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
          assert users(:jason).pending_friends.include? users(:mikethefrog)
        end

        should "redirect to friends profile page" do
          assert_response :redirect
          assert_redirected_to profile_path(users(:mikethefrog))
        end

        should "set the flash success message" do
          assert flash[:success]
          assert_equal "Friend request sent.", flash[:success]
        end
      end
    end
  end

  context "#accept" do
    context "when not logged in" do
      should "redirect to login page" do
        put :accept, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        @user_friendship = create(:pending_user_friendship, user: users(:jason))
        sign_in users(:jason)
        put :accept, id: @user_friendship
        @user_friendship.reload
      end

      should "assign a user friendship" do
        assert assigns(:user_friendship)
        assert_equal assigns(:user_friendship), @user_friendship
      end

      should "update the state to accepted" do
        assert_equal 'accepted', @user_friendship.state
      end

      should "have a flash success message" do
        assert flash[:success]
        assert_equal "You are now friends with #{@user_friendship.friend.first_name}.", flash[:success]
      end
    end
  end

  context "#edit" do
    context "when not logged in" do
      should "be redirected to login page" do
        get :edit, id: 1
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "when logged in" do
      setup do
        sign_in users(:jason)
        @user_friendship = create(:pending_user_friendship, user: users(:jason))
        get :edit, id: @user_friendship
      end

      should "get edit page when logged in" do
        assert_response :success
      end

      should "assign to user firendship" do
        assert assigns(:user_friendship)
      end

      should "assign to friend" do
        assert assigns(:friend)
      end
    end
  end
end