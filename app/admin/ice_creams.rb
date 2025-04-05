ActiveAdmin.register IceCream do
  menu parent: "Products"

  permit_params :name, :fixed_price, ice_cream_flavors_attributes: %i[id flavor_id quantity _destroy]

  filter :fixed_price
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name do |ice_cream|
      ice_cream.to_s
    end
    column :price do |ice_cream|
      number_to_currency(ice_cream.price)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :price do |ice_cream|
        number_to_currency(ice_cream.price)
      end
      row :created_at
      row :updated_at
    end

    panel "Flavors" do
      table_for ice_cream.ice_cream_flavors do
        column :flavor
        column :quantity
      end
    end
  end

  form partial: 'form'
end
