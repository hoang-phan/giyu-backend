module PricedItem
  extend ActiveSupport::Concern

  included do
    validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
    validates :name, presence: true
  end

  class_methods do
    def ransackable_attributes(auth_object = nil)
      [ "created_at", "id", "id_value", "name", "unit_price", "updated_at" ]
    end

    def ransackable_associations(auth_object = nil)
        []
    end
  end
end