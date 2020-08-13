class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
    @comment = current_user.comments.build(comment_params)
    @comment.surplus_land_id = @surplus_land.id
    if @comment.save
      flash[:success] = 'コメントを投稿しました'
      redirect_to @surplus_land
    else
      @comments = @surplus_land.comments.page(params[:page])
      render 'surplus_lands/show'
    end
  end

  def destroy
    surplus_land = SurplusLand.find(params[:surplus_land_id])
    @comment.destroy
    flash[:success] = 'コメントを削除しました'
    redirect_to surplus_land
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  # before_action

  def correct_user
    @comment = Comment.find(params[:id])
    redirect_to root_url unless current_user?(@comment.user)
  end
end
