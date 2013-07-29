class UserFriendshipsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user_friendships = current_user.user_friendships.all
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
      @user_friendship = current_user.user_friendships.new(friend: @friend, user: current_user)
      @user_friendship.save
      flash[:success] = "You are now friends with #{@friend.full_name}."
      redirect_to profile_path(@friend)
    else
      flash[:error] = "Friend Required"
      redirect_to root_path
    end
  end

end
