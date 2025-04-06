FactoryBot.define do
  factory :flavor do
    name { Faker::Dessert.flavor }
    unit_price { rand(100..1000) }
  end
end 