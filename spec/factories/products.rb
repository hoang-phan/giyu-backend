FactoryBot.define do
  factory :product do
    fixed_price { rand(100..1000) }
    type { 'Product' }
  end
end
