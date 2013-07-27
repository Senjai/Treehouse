class ProfilesController < ApplicationController
  before_filter :authenticate_user!, only: [:current_profile]
  def show
    @user = User.find_by_profile_name(params[:id])
    if @user
      @statuses = @user.statuses.all
      render action: :show
    else
      render file: 'public/404', status: 404, formats: [:html]
    end
  end

  def current_profile
    if user_signed_in?
      @user = User.find_by_profile_name(current_user.profile_name)
      @statuses = @user.statuses.all
      render action: :show
    else
      render file: 'public/404', status: 404, formats: [:html]
    end
  end
end
