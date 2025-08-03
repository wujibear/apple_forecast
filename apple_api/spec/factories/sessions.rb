FactoryBot.define do
  factory :session do
    association :user
    user_agent { "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" }
    ip_address { "192.168.1.1" }
  end
end
