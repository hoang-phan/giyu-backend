class IceCream < Product
  has_many :ice_cream_flavors, dependent: :destroy
  has_many :flavors, through: :ice_cream_flavors
  accepts_nested_attributes_for :ice_cream_flavors, allow_destroy: true, reject_if: :all_blank

  validates :fixed_price, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def self.ransackable_associations(auth_object = nil)
    []
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "fixed_price", "id", "id_value", "price", "type", "updated_at" ]
  end

  def to_s
    name.presence || flavors.map(&:name).uniq.join(' + ')
  end
  alias to_label to_s

  def price
    return fixed_price if fixed_price.present?

    all_flavors = ice_cream_flavors.includes(:flavor).to_a

    all_flavors.map do |ic_flavor|
      ic_flavor.quantity * ic_flavor.flavor.unit_price
    end.sum
  end
end
