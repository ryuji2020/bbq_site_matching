class AddColumnLatitudeToSurplusLands < ActiveRecord::Migration[5.2]
  def change
    add_column :surplus_lands, :latitude, :float
    add_column :surplus_lands, :longitude, :float
  end
end
