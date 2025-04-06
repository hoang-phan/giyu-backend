FactoryBot.define do
  factory :ice_cream_flavor do
    association :ice_cream
    association :flavor
    quantity { rand(1..5) }
  end
end 