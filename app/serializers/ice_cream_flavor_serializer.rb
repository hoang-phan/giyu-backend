class IceCreamFlavorSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :created_at, :updated_at

  belongs_to :ice_cream
  belongs_to :flavor
end 