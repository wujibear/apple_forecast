# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "🌱 Seeding database..."

# Configuration variables
DEFAULT_USER_EMAIL = "user@example.com"
DEFAULT_USER_PASSWORD = "password123"
DEFAULT_USER_POINTS = 2500
DEFAULT_REDEMPTIONS_COUNT = 3

# Create default user
default_user = User.find_or_create_by!(email_address: DEFAULT_USER_EMAIL) do |user|
  user.password = DEFAULT_USER_PASSWORD
  user.password_confirmation = DEFAULT_USER_PASSWORD
  user.points_balance = DEFAULT_USER_POINTS
end

puts "✅ Created default user: #{default_user.email_address} with #{default_user.points_balance} points"

# Create a list of rewards using FactoryBot
rewards = create_list(:reward, 10)
puts "✅ Created #{rewards.length} rewards"

# Sample affordable rewards for redemptions
affordable_rewards = rewards.select { |r| r.points <= 500 }
sampled_rewards = affordable_rewards.sample(DEFAULT_REDEMPTIONS_COUNT)

redemptions_created = 0

sampled_rewards.each do |reward|
  # Check if this redemption already exists for the user
  existing_redemption = Redemption.find_by(user: default_user, reward: reward)

  unless existing_redemption
    Redemption.create!(
      user: default_user,
      reward: reward,
      points_cost: reward.points
    )
    redemptions_created += 1
    puts "   - Redeemed: #{reward.name} (#{reward.points} points)"
  end
end

puts "✅ Created #{redemptions_created} redemptions for default user"

# Update user's points balance to reflect redemptions
total_redemption_cost = default_user.redemptions.sum(:points_cost)
if total_redemption_cost > 0
  default_user.update!(points_balance: DEFAULT_USER_POINTS - total_redemption_cost)
  puts "💰 Updated user points balance to #{default_user.points_balance} (after redemptions)"
end

puts "🎉 Seeding complete!"
puts "📊 Summary:"
puts "   - Users: #{User.count}"
puts "   - Rewards: #{Reward.count}"
puts "   - Redemptions: #{Redemption.count}"
puts ""
puts "🔑 Default user credentials:"
puts "   Email: #{DEFAULT_USER_EMAIL}"
puts "   Password: #{DEFAULT_USER_PASSWORD}"
puts "   Points: #{default_user.points_balance}"
