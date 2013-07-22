require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works" do
    UserFriendship.create user: users(:jason), friend: users(:mike)
    assert users(:jason).friends.include?(users(:mike))
  end
end
