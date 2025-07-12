FactoryBot.define do
  factory :reward do
    sequence(:name) { |n| "Reward #{n}" }
    points { rand(10..1000) }
  end
end
