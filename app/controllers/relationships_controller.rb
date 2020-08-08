class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])
    unless current_user.following?(@user)
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
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || @user }
      format.js
    end
  end
end
