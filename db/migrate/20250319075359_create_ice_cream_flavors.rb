class CreateIceCreamFlavors < ActiveRecord::Migration[8.0]
  def change
    create_table :ice_cream_flavors do |t|
      t.references :ice_cream, null: false, foreign_key: {to_table: :products}
      t.references :flavor, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
