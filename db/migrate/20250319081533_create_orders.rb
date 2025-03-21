class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.integer :total_amount
      t.string :status

      t.timestamps
      t.index :status
    end
  end
end
