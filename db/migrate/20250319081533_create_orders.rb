class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    change_table :orders do |t|
      # t.string :status
      t.integer :total_amount

      # t.timestamps
      # t.index :status
    end
  end
end
