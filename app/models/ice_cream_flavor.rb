class IceCreamFlavor < ApplicationRecord
  belongs_to :ice_cream
  belongs_to :flavor

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
