module RoomsHelper
  # 一度申込済みであれば、そこで作成されたルームを返す
  def find_room(surplus_land, visitor)
    Room.find_by(surplus_land_id: surplus_land.id, visitor_id: visitor.id)
  end
end
