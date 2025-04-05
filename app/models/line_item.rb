class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :discount_percent, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }, allow_nil: true
  before_save :calculate_amount

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "discount_percent", "id", "id_value", "order_id", "product_id", "quantity", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "order", "product" ]
  end

  def amount_with_fallback
    amount || final_price
  end

  def final_price
    price = product.price * quantity
    (price * (1 - discount_percent.to_f / 100)).to_i
  end

  private

  def calculate_amount
    return if !quantity_changed? && !discount_percent_changed? && !product_id_changed?
    self.amount = final_price
  end
end
