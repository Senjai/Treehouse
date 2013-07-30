class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user_friendships = current_user.user_friendships.all
  end

  def accept
    @user_friendship = current_user.user_friendships.find(params[:id])
    if @user_friendship.accept!
      flash[:success] = "You are now friends with #{@user_friendship.friend.first_name}."
    else
      flash[:error] = "That friendship could not be accepted."
    end
    redirect_to user_friendships_path
  end

  def new
    if params[:friend_id]
      @friend = User.where(profile_name: params[:friend_id]).first
      raise ActiveRecord::RecordNotFound if @friend.nil?
      @user_friendship = current_user.user_friendships.new(friend: @friend)
    else
      flash[:error] = "Friend Required"
    end
  rescue ActiveRecord::RecordNotFound => e
    render file: 'public/404', status: :not_found
    logger.error(e)
  end

  def create
    if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
      @friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
      @user_friendship = UserFriendship.request(current_user, @friend)
      if @user_friendship.new_record?
        flash[:error] = "There was a problem creating that friend request."
      else
        flash[:success] = "Friend request sent."
      end
      redirect_to profile_path(@friend)
    else
      flash[:error] = "Friend Required"
      redirect_to root_path
    end
  end

  def edit
    u_f = current_user.user_friendships.find(params[:id])
    @user_friendship = u_f.decorate
    @friend = u_f.friend
  end

  def destroy
    if current_user.user_friendships.find(params[:id]).destroy
      flash[:success] = "Friendship Destroyed"
    end
    redirect_to user_friendships_path
  end

end
