ActiveAdmin.register Flavor do
  extend PricedItemManageable

  menu parent: "Settings"

  has_priced_item
end
