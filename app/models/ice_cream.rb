class IceCream < Product
  has_many :ice_cream_flavors, dependent: :destroy
  has_many :flavors, through: :ice_cream_flavors

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "fixed_price", "id", "id_value", "price", "type", "updated_at"]
  end

  def price
    all_flavors = ice_cream_flavors.includes(:flavor).to_a
    return fixed_price if all_flavors.blank?

    all_flavors.map do |ic_flavor|
      ic_flavor.quantity * ic_flavor.flavor.unit_price
    end.sum
  end
end
