class LineItemSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :discount_percent, :final_price, :created_at, :updated_at

  belongs_to :order, serializer: OrderSerializer
  belongs_to :product, serializer: ProductSerializer

  def final_price
    object.final_price || (object.product&.fixed_price.to_f * (1 - (object.discount_percent.to_f / 100)) * object.quantity)
  end
end 