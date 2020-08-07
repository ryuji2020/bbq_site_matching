class LikesController < ApplicationController
  before_action :authenticate_user!

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
    like = Like.find(params[:id])
    like.destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
