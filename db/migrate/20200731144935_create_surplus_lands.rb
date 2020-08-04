class CreateSurplusLands < ActiveRecord::Migration[5.2]
  def change
    create_table :surplus_lands do |t|
      t.string :title
      t.integer :price
      t.string :state
      t.text :description
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :surplus_lands, :state
  end
end
