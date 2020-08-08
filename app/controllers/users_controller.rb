class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @own_surplus_lands = @user.surplus_lands
    @like_surplus_lands = @user.like_surplus_lands.page(params[:page])
  end
end
