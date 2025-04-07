FactoryBot.define do
  factory :topping do
    name { Faker::Dessert.topping }
    unit_price { rand(100..1000) }
  end
end
