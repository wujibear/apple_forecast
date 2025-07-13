class User < ApplicationRecord
  include HasNanoid
  
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :redemptions, dependent: :destroy
  has_many :rewards, through: :redemptions

  validates :email_address, presence: true, uniqueness: { case_sensitive: false }
  normalizes :email_address, with: ->(e) { e.strip.downcase }
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email_address   :string           not null
#  nanoid          :string
#  password_digest :string           not null
#  points_balance  :integer          default(0)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email_address  (email_address) UNIQUE
#  index_users_on_nanoid         (nanoid) UNIQUE
#
