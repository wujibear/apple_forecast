class Reward < ApplicationRecord
  include HasNanoid
  
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :points, presence: true, numericality: { greater_than: 0 }
end

# == Schema Information
#
# Table name: rewards
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  nanoid     :string
#  points     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_rewards_on_name    (name) UNIQUE
#  index_rewards_on_nanoid  (nanoid) UNIQUE
#
