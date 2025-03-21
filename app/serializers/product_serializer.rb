class ProductSerializer < ActiveModel::Serializer
  attributes :id, :type, :fixed_price, :created_at, :updated_at

  def fixed_price
    object.fixed_price.to_f
  end
end 