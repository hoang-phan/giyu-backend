class IceCreamTopping < ApplicationRecord
  belongs_to :ice_cream
  belongs_to :topping

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }, presence: true
end