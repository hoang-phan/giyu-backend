class FlavorSerializer < ActiveModel::Serializer
  attributes :id, :name, :unit_price, :created_at, :updated_at

  def unit_price
    object.unit_price.to_f
  end
end
