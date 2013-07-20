require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "a user should enter their first name" do
    user = User.new
    assert !user.save
    assert !user.errors[:first_name].empty?
    puts user.first_name
  end

  test "a user should enter their last name" do
    user = User.new
    assert !user.save
    assert !user.errors[:last_name].empty?
  end

  test "a user should enter their profile name" do
    user = User.new
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "the user should have a unique profile name" do
    user = User.new
    user.profile_name = users(:jason).profile_name
    assert !user.save, "saved"
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile_name without spaces" do
    user = User.new
    user.profile_name = "My Profule with Spaces"

    assert !user.save, "User was saved"
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end
end
