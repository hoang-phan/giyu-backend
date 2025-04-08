ActiveAdmin.register Order do
  permit_params :status, line_items_attributes: %i[id product_id quantity discount_percent _destroy]

  index do
    selectable_column
    id_column
    column :status
    column :created_at
    column :updated_at
    column :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    actions defaults: true do |order|
      order.aasm.events.select { |event| order.aasm.may_fire_event?(event.name) }.map do |event|
        link_to event.to_s.titleize, transition_status_admin_order_path(order, event: event), method: :post, class: "member_link"
      end.join(" ").html_safe
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
      row :created_at
      row :updated_at
      row :total_amount do |order|
        number_to_currency(order.total_amount)
      end
    end

    panel "Line Items" do
      table_for order.line_items do
        column :product do |item|
          link_to item.product.to_s, [ :admin, item.product ]
        end
        column :quantity
        column :discount_percent do |item|
          number_to_percentage(item.discount_percent.to_f)
        end
        column :amount do |item|
          number_to_currency(item.amount)
        end
      end
    end
  end

  form partial: "form"

  member_action :transition_status, method: :post do
    service = OrderStatusTransitionService.new(resource, params[:event])
    if service.call
      redirect_to admin_orders_path, notice: "Order status updated to #{resource.status}"
    else
      redirect_to admin_orders_path, alert: service.error
    end
  end
end
