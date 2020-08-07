class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
    current_user.like(@surplus_land)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
    @like.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  private

  # before_action

  def correct_user
    @like = Like.find(params[:id])
    redirect_to root_url unless current_user?(@like.user)
  end
end
