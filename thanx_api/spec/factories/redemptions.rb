FactoryBot.define do
  factory :redemption do
    association :user
    association :reward
    points_cost { rand(10..500) }
  end
end
