ActiveAdmin.register IceCream do
  menu parent: 'Products'
  
  permit_params :fixed_price

  filter :fixed_price
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :fixed_price do |ice_cream|
      number_to_currency(ice_cream.fixed_price)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :fixed_price do |ice_cream|
        number_to_currency(ice_cream.fixed_price)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :fixed_price, input_html: { min: 0, step: 0.01 }
    end
    f.actions
  end
end 