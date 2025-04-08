class IceCreamToppingSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :created_at, :updated_at

  belongs_to :ice_cream
  belongs_to :topping
end
