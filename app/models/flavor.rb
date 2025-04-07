class Flavor < ApplicationRecord
  include PricedItem

  has_many :ice_cream_flavors, dependent: :destroy
end
