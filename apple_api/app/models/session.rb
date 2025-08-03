class Session < ApplicationRecord
  belongs_to :user

  before_create :generate_secure_token

  private

  def generate_secure_token
    loop do
      self.token = SecureRandom.urlsafe_base64(32)
      break unless self.class.exists?(token: token)
    end
  end
end

# == Schema Information
#
# Table name: sessions
#
#  id         :integer          not null, primary key
#  ip_address :string
#  token      :string
#  user_agent :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
# Indexes
#
#  index_sessions_on_token    (token) UNIQUE
#  index_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  user_id  (user_id => users.id)
#
