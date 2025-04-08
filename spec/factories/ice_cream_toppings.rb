FactoryBot.define do
  factory :ice_cream_topping do
    association :ice_cream
    association :topping
    quantity { rand(1..5) }
  end
end
