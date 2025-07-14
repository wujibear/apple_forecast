FactoryBot.define do
  factory :reward do
    name { Faker::Commerce.product_name }
    points { Faker::Number.number(digits: 4) }
  end
end
