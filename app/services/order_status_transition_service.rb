class OrderStatusTransitionService
  def initialize(order, event)
    @order = order
    @event = event.to_sym
  end

  def call
    order.aasm.fire!(event)
    true
  rescue AASM::InvalidTransition, AASM::UndefinedEvent => e
    @error = e.message
    false
  end

  def error
    @error
  end

  private

  attr_reader :order, :event
end
