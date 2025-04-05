ActiveAdmin.register Flavor do
  menu parent: "Settings"

  permit_params :name, :unit_price

  filter :name
  filter :unit_price
  filter :created_at
  filter :updated_at

  index do
    selectable_column
    id_column
    column :name
    column :unit_price do |flavor|
      number_to_currency(flavor.unit_price)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :unit_price do |flavor|
        number_to_currency(flavor.unit_price)
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :name
      f.input :unit_price, input_html: { min: 0, step: 0.01 }
    end
    f.actions
  end
end
