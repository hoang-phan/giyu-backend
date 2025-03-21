ActiveAdmin.register LineItem do
  menu parent: 'Orders', priority: 2
  # Specify parameters which should be permitted for assignment
  permit_params :order_id, :product_id, :quantity, :discount_percent

  # or consider:
  #
  # permit_params do
  #   permitted = [:order_id, :product_id, :quantity, :discount_percent]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :order
  filter :product
  filter :quantity
  filter :discount_percent
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :order
    column :product
    column :quantity
    column :discount_percent do |line_item|
      number_to_percentage(line_item.discount_percent, precision: 2) if line_item.discount_percent
    end
    column :final_price do |line_item|
      number_to_currency(line_item.final_price)
    end
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table do
      row :id
      row :order
      row :product
      row :quantity
      row :discount_percent do |line_item|
        number_to_percentage(line_item.discount_percent, precision: 2) if line_item.discount_percent
      end
      row :final_price do |line_item|
        number_to_currency(line_item.final_price)
      end
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :order
      f.input :product
      f.input :quantity
      f.input :discount_percent, input_html: { min: 0, max: 100, step: 0.01 }
    end
    f.actions
  end
end
