class Redemption < ApplicationRecord
  belongs_to :user
  belongs_to :reward

  validates :points_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }
end

# == Schema Information
#
# Table name: redemptions
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  reward_id   :integer          not null
#  points_cost :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_redemptions_on_reward_id              (reward_id)
#  index_redemptions_on_user_id                (user_id)
#  index_redemptions_on_user_id_and_reward_id  (user_id,reward_id)
#
