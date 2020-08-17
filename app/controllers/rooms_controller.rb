class RoomsController < ApplicationController
  before_action :authenticate_user!

  def show
    @room = Room.find(params[:id])
    surplus_land = @room.surplus_land
    if request.referrer == surplus_land_url(surplus_land) && current_user != surplus_land.user
      current_user.send_messages.create(
        content: 'もう一度行きたいです！',
        receiver_id: surplus_land.user_id,
        room_id: @room.id
      )
    end
    @messages = Message.where(room_id: @room.id).includes(:sender)
  end

  def create
    surplus_land = SurplusLand.find(params[:surplus_land_id])
    room = surplus_land.rooms.build(visitor_id: current_user.id)
    if room.save
      current_user.send_messages.create(
        content: '行ってみたいです！',
        receiver_id: surplus_land.user_id,
        room_id: room.id
      )
      redirect_to room
    else
      redirect_to surplus_land
    end
  end
end
