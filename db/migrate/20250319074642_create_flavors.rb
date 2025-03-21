class CreateFlavors < ActiveRecord::Migration[8.0]
  def change
    create_table :flavors do |t|
      t.string :name
      t.integer :unit_price

      t.timestamps
    end
  end
end
