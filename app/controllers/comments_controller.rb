class CommentsController < ApplicationController
  include AjaxHelper
  before_action :ajax_authenticate_user
  before_action :correct_user, only: [:destroy]

  def create
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
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
        format.js { @comments = @surplus_land.comments.includes(:user).page(params[:page]) } # pagenationにするか？未定
      end
    else
      @comments = @surplus_land.comments.includes(:user).page(params[:page]) # pagenationにするか？未定
      respond_to do |format|
        format.html { render 'surplus_lands/show' }
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
      format.js { @comments = @surplus_land.comments.includes(:user).page(params[:page]) } # pagenationにするか？未定
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
