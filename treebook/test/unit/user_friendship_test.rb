require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising an exception" do
    assert_nothing_raised do
      UserFriendship.create user: users(:jim), friend: users(:mikethefrog)
    end
  end

  test "that creatinga  friendship based on user id and friend id works" do
    UserFriendship.create user_id: users(:jason).id, friend_id: users(:mikethefrog).id
    assert users(:jason).pending_friends.include? users(:mikethefrog)
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:jason), friend: users(:mikethefrog)
    end

    should "have a pending state after initialization" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:jason), friend: users(:mikethefrog)
    end

    should "send an email" do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        @user_friendship.send_request_email
      end
    end
  end

  context "#mutual_friendship" do
    setup do
      UserFriendship.request users(:jason), users(:jim)
      @friendship1 = users(:jason).user_friendships.where(friend_id: users(:jim).id).first
      @friendship2 = users(:jim).user_friendships.where(friend_id: users(:jason).id).first
    end

    should "correctly find the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
    end
  end

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:jason), users(:jim)
    end

    should "accept the mutual friendship" do
      friendship1 = users(:jason).user_friendships.where(friend_id: users(:jim).id).first
      friendship2 = users(:jim).user_friendships.where(friend_id: users(:jason).id).first

      friendship1.accept_mutual_friendship!

      friendship2.reload
      assert_equal friendship2.state, "accepted"
    end
  end

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.request users(:jason), users(:mikethefrog)
    end

    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal @user_friendship.state, "accepted"
    end

    should "send an acceptance email" do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        @user_friendship.accept!
      end
    end

    should "include the friend in the list of friends" do
      @user_friendship.accept!
      assert users(:jason).friends.reload.include? users(:mikethefrog)
    end

    should "accept the mutual friendship" do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state
    end
  end

  context ".request" do
    should "create two user friendships" do
      assert_difference "UserFriendship.count", 2 do
        UserFriendship.request(users(:jason), users(:mikethefrog))
      end
    end

    should "send a friend request email" do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        UserFriendship.request(users(:jason), users(:mikethefrog))
      end
    end
  end

end
