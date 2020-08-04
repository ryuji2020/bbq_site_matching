class AddColumnToSurplusLands < ActiveRecord::Migration[5.2]
  def change
    add_column :surplus_lands, :address, :string
  end
end
