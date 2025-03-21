ActiveAdmin.register Order do
  menu parent: 'Orders', priority: 1

  permit_params :status, :total_amount, line_items_attributes: [:id, :product_id, :quantity, :discount_percent, :_destroy]

  index do
    selectable_column
    id_column
    column :status
    column :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    column :created_at
    column :updated_at
    actions defaults: true do |order|
      order.aasm.events.select { |event| order.aasm.may_fire_event?(event.name) }.map do |event|
        link_to event.to_s.titleize, transition_status_admin_order_path(order, event: event), method: :post, class: 'member_link'
      end.join(' ').html_safe
    end
  end

  filter :status, as: :select, collection: Order.aasm.states.map(&:name)
  filter :total_amount
  filter :created_at
  filter :updated_at

  show do
    attributes_table do
      row :id
      row :status
      row :total_amount do |order|
        number_to_currency(order.total_amount)
      end
      row :created_at
      row :updated_at
    end

    panel 'Line Items' do
      table_for order.line_items do
        column :product
        column :quantity
        column :discount_percent
        column :final_price do |item|
          number_to_currency(item.final_price)
        end
      end
    end
  end

  form partial: 'form'

  member_action :transition_status, method: :post do
    service = OrderStatusTransitionService.new(resource, params[:event])
    if service.call
      redirect_to admin_orders_path, notice: "Order status updated to #{resource.status}"
    else
      redirect_to admin_orders_path, alert: service.error
    end
  end
end 