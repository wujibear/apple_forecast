require "rails_helper"

RSpec.describe Redemption, type: :model do
  # Shoulda-matchers shorthand for validations
  it { is_expected.to validate_presence_of(:points_cost) }
  it { is_expected.to validate_numericality_of(:points_cost).is_greater_than_or_equal_to(0) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:reward) }

  describe "#points_cost" do
    it "validates non-numeric points_cost" do
      redemption = build(:redemption, points_cost: "not a number")

      aggregate_failures do
        expect(redemption).not_to be_valid
        expect(redemption.errors[:points_cost]).to include("is not a number")
      end
    end

    it "validates negative points_cost" do
      redemption = build(:redemption, points_cost: -10)

      aggregate_failures do
        expect(redemption).not_to be_valid
        expect(redemption.errors[:points_cost]).to include("must be greater than or equal to 0")
      end
    end
  end

  describe "associations" do
    it "validates missing user" do
      redemption = build(:redemption, user: nil)

      aggregate_failures do
        expect(redemption).not_to be_valid
        expect(redemption.errors[:user]).to include("must exist")
      end
    end

    it "validates missing reward" do
      redemption = build(:redemption, reward: nil)

      aggregate_failures do
        expect(redemption).not_to be_valid
        expect(redemption.errors[:reward]).to include("must exist")
      end
    end
  end

  describe "database constraints" do
    let(:user) { create(:user) }
    let(:reward) { create(:reward) }

    it "enforces user_id presence" do
      expect {
        described_class.connection.execute("INSERT INTO redemptions (reward_id, points_cost, created_at, updated_at) VALUES (#{reward.id}, 100, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "enforces reward_id presence" do
      expect {
        described_class.connection.execute("INSERT INTO redemptions (user_id, points_cost, created_at, updated_at) VALUES (#{user.id}, 100, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end

    it "enforces points_cost presence" do
      expect {
        described_class.connection.execute("INSERT INTO redemptions (user_id, reward_id, created_at, updated_at) VALUES (#{user.id}, #{reward.id}, '#{Time.current}', '#{Time.current}')")
      }.to raise_error(ActiveRecord::StatementInvalid)
    end
  end

  describe "before_validation callback" do
    let(:user) { create(:user) }
    let(:reward) { create(:reward, name: "Coffee Reward", points: 500) }

    it "saves reward meta if not provided" do
      redemption = build(:redemption, user:, reward:)
      redemption.save!

      aggregate_failures do
        expect(redemption.points_cost).to eq(reward.points)
        expect(redemption.reward_name).to eq(reward.name)
      end
    end

    it "does not override existing points_cost" do
      redemption = build(:redemption, user:, reward:, points_cost: 300)
      redemption.save!

      expect(redemption.points_cost).to eq(300)
    end

    it "does not override existing reward_name" do
      redemption = build(:redemption, user:, reward:, reward_name: "Custom Name")
      redemption.save!

      expect(redemption.reward_name).to eq("Custom Name")
    end
  end
end
