class UsersController < ApplicationController
  before_action :get_user

  def show
    @own_surplus_lands = @user.surplus_lands.includes(images_attachments: :blob)
    @like_surplus_lands = @user.like_surplus_lands.includes(images_attachments: :blob).page(params[:page])
  end

  def following
    @title = 'following'
    @page_title = 'フォロー中のユーザー'
    @relationship_users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'followers'
    @page_title = 'フォロワー'
    @relationship_users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

  # before_action

  def get_user
    @user = User.find(params[:id])
  end
end
