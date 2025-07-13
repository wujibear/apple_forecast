class Redemption < ApplicationRecord
  before_save :save_reward_meta

  belongs_to :user
  belongs_to :reward

  validates :points_cost, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def save_reward_meta
    self.points_cost ||= reward.points
    self.reward_name ||= reward.name
  end
end

# == Schema Information
#
# Table name: redemptions
#
#  id          :integer          not null, primary key
#  points_cost :integer          not null
#  reward_name :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  reward_id   :integer          not null
#  user_id     :integer          not null
#
# Indexes
#
#  index_redemptions_on_reward_id              (reward_id)
#  index_redemptions_on_user_id                (user_id)
#  index_redemptions_on_user_id_and_reward_id  (user_id,reward_id)
#
