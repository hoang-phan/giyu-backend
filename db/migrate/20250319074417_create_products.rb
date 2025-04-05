class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name
      t.string :type
      t.float :discount_percent
      t.integer :fixed_price

      t.timestamps
    end
    add_index :products, :type
  end
end
