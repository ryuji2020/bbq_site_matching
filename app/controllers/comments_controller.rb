class CommentsController < ApplicationController
  include AjaxHelper
  before_action :ajax_authenticate_user
  before_action :correct_user, only: [:destroy]

  def create
    @surplus_land = SurplusLand.includes(images_attachments: :blob).find(params[:surplus_land_id])
    @comment = current_user.comments.build(comment_params)
    @comment.surplus_land_id = @surplus_land.id
    if @comment.save
      @comment.create_notification(current_user)
      @message = 'コメントを投稿しました'
      respond_to do |format|
        format.html do
          flash[:success] = @message
          redirect_to @surplus_land
        end
        format.js do
          @latest_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).limit(3)
          @previous_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).offset(3)
        end
      end
    else
      @latest_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).limit(3)
      @previous_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).offset(3)
      respond_to do |format|
        format.html do
          flash.now[:danger] = '400文字以内でコメントを入力してください'
          render 'surplus_lands/show'
        end
        format.js
      end
    end
  end

  def destroy
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
    @comment.destroy
    respond_to do |format|
      format.html do
        flash[:success] = 'コメントを削除しました'
        redirect_to @surplus_land
      end
      format.js do
        @latest_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).limit(3)
        @previous_comments = @surplus_land.comments.includes(:user).order(created_at: :desc).offset(3)
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  # before_action

  def ajax_authenticate_user
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to new_user_session_path }
        format.js { render ajax_redirect_to(new_user_session_path) }
      end
    end
  end

  def correct_user
    @comment = Comment.find(params[:id])
    unless current_user?(@comment.user)
      respond_to do |format|
        format.html { redirect_to root_url }
        format.js { render ajax_redirect_to(root_url) }
      end
    end
  end
end
