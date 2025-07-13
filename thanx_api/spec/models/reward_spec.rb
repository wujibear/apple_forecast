require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:points) }
  it { is_expected.to validate_numericality_of(:points).is_greater_than(0) }

  # Test uniqueness manually since shoulda-matchers has issues with NOT NULL constraints
  describe '#name' do
    before do
      create(:reward, name: 'Coffee Reward')
    end

    it 'prevents duplicate names' do
      duplicate_reward = build(:reward, name: 'Coffee Reward')
      expect(duplicate_reward).not_to be_valid
    end

    it 'includes error message for duplicate names' do
      duplicate_reward = build(:reward, name: 'Coffee Reward')
      duplicate_reward.valid?
      expect(duplicate_reward.errors[:name]).to include('has already been taken')
    end

    it 'prevents case insensitive duplicates' do
      duplicate_reward = build(:reward, name: 'COFFEE REWARD')
      expect(duplicate_reward).not_to be_valid
    end

    it 'includes error message for case insensitive duplicates' do
      duplicate_reward = build(:reward, name: 'COFFEE REWARD')
      duplicate_reward.valid?
      expect(duplicate_reward.errors[:name]).to include('has already been taken')
    end

    it 'prevents and errors on duplicate names' do
      duplicate_reward = build(:reward, name: 'Coffee Reward')
      duplicate_reward2 = build(:reward, name: 'COFFEE REWARD')
      aggregate_failures do
        expect(duplicate_reward).not_to be_valid
        duplicate_reward.valid?
        expect(duplicate_reward.errors[:name]).to include('has already been taken')
        expect(duplicate_reward2).not_to be_valid
        duplicate_reward2.valid?
        expect(duplicate_reward2.errors[:name]).to include('has already been taken')
      end
    end

    describe 'with database constraints' do
      it 'enforces name uniqueness' do
        expect {
          described_class.connection.execute("INSERT INTO rewards (name, points, created_at, updated_at) VALUES ('Coffee Reward', 200, '#{Time.current}', '#{Time.current}')")
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
