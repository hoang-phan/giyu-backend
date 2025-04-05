class OrderSerializer < ActiveModel::Serializer
  attributes :id, :total_amount, :status, :created_at, :updated_at
  has_many :line_items
end
