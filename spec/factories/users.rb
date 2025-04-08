FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::PhoneNumber.cell_phone }
    birth_day { rand(1..28) }
    birth_month { rand(1..12) }
    birth_year { rand(1960..2000) }
    registration_date { Date.current }
    last_active_at { Time.current }
  end
end
