class MoveDiscountPercentFromProductToLineItem < ActiveRecord::Migration[7.1]
  def change
    remove_column :products, :discount_percent, :decimal
  end
end
