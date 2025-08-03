class PopulateNanoidsForExistingRecords < ActiveRecord::Migration[8.0]
  def up
    # Populate nanoids for existing users
    User.where(nanoid: nil).find_each do |user|
      user.update_column(:nanoid, Nanoid.generate(size: 12))
    end

    # Populate nanoids for existing rewards
    Reward.where(nanoid: nil).find_each do |reward|
      reward.update_column(:nanoid, Nanoid.generate(size: 12))
    end

    # Populate nanoids for existing redemptions
    Redemption.where(nanoid: nil).find_each do |redemption|
      redemption.update_column(:nanoid, Nanoid.generate(size: 12))
    end
  end

  def down
    # This migration cannot be safely reversed
    raise ActiveRecord::IrreversibleMigration
  end
end
