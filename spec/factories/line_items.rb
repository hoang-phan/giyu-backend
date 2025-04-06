FactoryBot.define do
  factory :line_item do
    association :order
    association :product
    quantity { rand(1..5) }
    discount_percent { rand(0..100) }
  end
end 