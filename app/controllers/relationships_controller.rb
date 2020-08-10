class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :store_location

  def create
    if session[:before_url] == following_user_url(current_user) || followers_user_url(current_user)
      @current_user = current_user
    end

    @user = User.find(params[:followed_id])
    if !current_user.following?(@user)
      current_user.follow(@user)
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
    if session[:before_url] == following_user_url(current_user) || followers_user_url(current_user)
      @current_user = current_user
    end

    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || @user }
      format.js
    end
  end

  private

  # before_action

  # 自分のフォロー中やフォロワーからフォローしたり解除する時に動的にstatsを変更させるために、
  # 直前のurlを覚えておく（後のアクションで自分ページの場合は@current_userを保持）
  def store_location
    session[:before_url] = request.original_url
  end
end
