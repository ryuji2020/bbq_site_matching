class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: [:show]
  before_action :only_visit_user, only: [:create]

  def show
    surplus_land = @room.surplus_land
    if request.referrer == surplus_land_url(surplus_land) && current_user != surplus_land.user && !session[:last_request]
      current_user.send_messages.create(
        content: 'もう一度行きたいです！',
        receiver_id: surplus_land.user_id,
        room_id: @room.id
      )
    end
    @messages = Message.where(room_id: @room.id).includes(:sender)
    session.delete(:last_request)
  end

  def create
    room = @surplus_land.rooms.build(visitor_id: current_user.id)
    if room.save
      current_user.send_messages.create(
        content: '行ってみたいです！',
        receiver_id: @surplus_land.user_id,
        room_id: room.id
      )
      session[:last_request] = request.original_url # createを経由しているか否かがわかればいいのでUrlである必要はない
      redirect_to room
    else
      redirect_to @surplus_land
    end
  end

  private

  #before_action

  def correct_user
    @room = Room.find(params[:id])
    unless current_user?(@room.owner) || current_user?(@room.visitor)
      redirect_to root_url
    end
  end

  def only_visit_user
    @surplus_land = SurplusLand.find(params[:surplus_land_id])
    redirect_to root_url if current_user?(@surplus_land.user)
  end
end
