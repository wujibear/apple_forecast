require 'rails_helper'

RSpec.describe Redemption, type: :model do
  # Shoulda-matchers shorthand for validations
  it { should validate_presence_of(:points_cost) }
  it { should validate_numericality_of(:points_cost).is_greater_than_or_equal_to(0) }
  it { should belong_to(:user) }
  it { should belong_to(:reward) }

  describe '#points_cost' do
    it 'requires points_cost' do
      redemption = build(:redemption, points_cost: nil)
      expect(redemption).not_to be_valid
      expect(redemption.errors[:points_cost]).to include("can't be blank")
    end

    it 'requires points_cost to be a number' do
      redemption = build(:redemption, points_cost: 'not a number')
      expect(redemption).not_to be_valid
      expect(redemption.errors[:points_cost]).to include('is not a number')
    end

    it 'allows zero points cost' do
      redemption = build(:redemption, points_cost: 0)
      expect(redemption).to be_valid
    end

    it 'allows positive points cost' do
      redemption = build(:redemption, points_cost: 100)
      expect(redemption).to be_valid
    end

    it 'prevents negative points cost' do
      redemption = build(:redemption, points_cost: -10)
      expect(redemption).not_to be_valid
      expect(redemption.errors[:points_cost]).to include('must be greater than or equal to 0')
    end
  end

  describe 'associations' do
    it 'requires a user' do
      redemption = build(:redemption, user: nil)
      expect(redemption).not_to be_valid
      expect(redemption.errors[:user]).to include('must exist')
    end

    it 'requires a reward' do
      redemption = build(:redemption, reward: nil)
      expect(redemption).not_to be_valid
      expect(redemption.errors[:reward]).to include('must exist')
    end
  end

  describe 'database constraints' do
    let(:user) { create(:user) }
    let(:reward) { create(:reward) }

    it 'enforces user_id presence' do
      expect {
        Redemption.connection.execute("INSERT INTO redemptions (reward_id, points_cost, created_at, updated_at) VALUES (#{reward.id}, 100, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'enforces reward_id presence' do
      expect {
        Redemption.connection.execute("INSERT INTO redemptions (user_id, points_cost, created_at, updated_at) VALUES (#{user.id}, 100, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it 'enforces points_cost presence' do
      expect {
        Redemption.connection.execute("INSERT INTO redemptions (user_id, reward_id, created_at, updated_at) VALUES (#{user.id}, #{reward.id}, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end
end
