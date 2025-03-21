ActiveAdmin.register IceCreamFlavor do
  menu parent: 'Settings'
  
  permit_params :ice_cream_id, :flavor_id, :quantity

  index do
    selectable_column
    id_column
    column :ice_cream
    column :flavor
    column :quantity
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :ice_cream
      row :flavor
      row :quantity
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :ice_cream, collection: IceCream.all.map { |ic| [ic.id, ic.id] }
      f.input :flavor, collection: Flavor.all.map { |f| [f.name, f.id] }
      f.input :quantity, input_html: { min: 1 }
    end
    f.actions
  end
end 