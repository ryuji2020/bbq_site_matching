class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    if request.referrer == following_user_url(current_user) || followers_user_url(current_user)
      @current_user = current_user
    end

    @user = User.find(params[:followed_id])
    if !current_user.following?(@user)
      current_user.follow(@user)
      @user.create_follow_notification(current_user)
      respond_to do |format|
        format.html { redirect_to request.referrer || @user }
        format.js
      end
    else
      @own_surplus_lands = @user.surplus_lands
      @like_surplus_lands = @user.like_surplus_lands.page(params[:page])
      render 'users/show'
    end
  end

  def destroy
    if request.referrer == following_user_url(current_user) || followers_user_url(current_user)
      @current_user = current_user
    end

    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || @user }
      format.js
    end
  end
end
