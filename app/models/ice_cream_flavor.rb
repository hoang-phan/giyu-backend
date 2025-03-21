class IceCreamFlavor < ApplicationRecord
  belongs_to :ice_cream
  belongs_to :flavor

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "flavor_id", "id", "id_value", "ice_cream_id", "quantity", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["flavor", "ice_cream"]
  end
end
