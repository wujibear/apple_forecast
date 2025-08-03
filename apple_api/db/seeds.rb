# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

require 'factory_bot_rails'
include FactoryBot::Syntax::Methods

puts "🌱 Seeding database..."

# Configuration variables
DEFAULT_USER_EMAIL = "user@example.com"
DEFAULT_USER_PASSWORD = "password123"

# Create default user
default_user = User.find_or_create_by!(email_address: DEFAULT_USER_EMAIL) do |user|
  user.password = DEFAULT_USER_PASSWORD
  user.password_confirmation = DEFAULT_USER_PASSWORD
  user.points_balance = DEFAULT_USER_POINTS
end

puts "✅ Created default user: #{default_user.email_address} with #{default_user.points_balance} points"


puts "🎉 Seeding complete!"
puts "📊 Summary:"
puts "   - Users: #{User.count}"
puts ""
puts "🔑 Default user credentials:"
puts "   Email: #{DEFAULT_USER_EMAIL}"
puts "   Password: #{DEFAULT_USER_PASSWORD}"
