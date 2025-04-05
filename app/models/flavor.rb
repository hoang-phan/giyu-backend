class Flavor < ApplicationRecord
  has_many :ice_cream_flavors, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "id_value", "name", "unit_price", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
