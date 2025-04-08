ActiveAdmin.register IceCreamTopping do
  extend PricedItemManageable

  menu parent: "Settings"

  has_priced_item
end 