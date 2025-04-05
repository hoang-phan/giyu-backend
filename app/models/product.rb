class Product < ApplicationRecord
  has_many :line_items, dependent: :restrict_with_error
  alias_attribute :price, :fixed_price

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "fixed_price", "id", "id_value", "type", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "line_items" ]
  end
end
