class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:destroy]

  def create
    @room = Room.find(params[:room_id])
    message = current_user.send_messages.build(message_params.merge(room_id: @room.id))
    if message.save
      redirect_to @room
    else
      @messages = Message.where(room_id: @room.id).includes(:sender)
      flash.now[:danger] = '140文字以内でメッセージを入力してください'
      render 'rooms/show'
    end
  end

  def destroy
    room = Room.find(params[:room_id])
    @message.destroy
    redirect_to room
  end

  private

  def message_params
    params.require(:message).permit(:content, :receiver_id)
  end

  # before_action

  def correct_user
    @message = Message.find(params[:id])
    redirect_to root_url unless current_user?(@message.sender)
  end
end
