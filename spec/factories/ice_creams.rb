FactoryBot.define do
  factory :ice_cream do
    fixed_price { rand(100..1000) }
    type { 'IceCream' }
  end
end 