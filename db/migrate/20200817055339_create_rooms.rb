class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.references :surplus_land, foreign_key: true
      t.integer :visitor_id

      t.timestamps
    end
  end
end
