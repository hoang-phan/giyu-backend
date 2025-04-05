class Order < ApplicationRecord
  include AASM

  has_many :line_items, dependent: :destroy
  accepts_nested_attributes_for :line_items, allow_destroy: true, reject_if: :all_blank

  before_save :calculate_total_amount

  aasm column: :status do
    state :ordering, initial: true
    state :waiting_payment
    state :queueing
    state :producing
    state :delivering
    state :completed

    event :confirm do
      transitions from: :ordering, to: :waiting_payment
    end

    event :queue do
      transitions from: :waiting_payment, to: :queueing
    end

    event :start_production do
      transitions from: :queueing, to: :producing
    end

    event :finish_production do
      transitions from: :producing, to: :delivering
    end

    event :deliver do
      transitions from: :delivering, to: :completed
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    [ "created_at", "id", "id_value", "status", "total_amount", "updated_at" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "line_items" ]
  end

  private

  def calculate_total_amount
    self.total_amount = line_items.sum(&:amount_with_fallback)
  end
end
