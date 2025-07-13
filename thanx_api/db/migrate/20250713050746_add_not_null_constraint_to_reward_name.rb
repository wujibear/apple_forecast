class AddNotNullConstraintToRewardName < ActiveRecord::Migration[8.0]
  def change
    change_column_null :redemptions, :reward_name, false
  end
end
