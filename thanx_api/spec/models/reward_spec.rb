require 'rails_helper'

RSpec.describe Reward, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:points) }
  it { should validate_numericality_of(:points).is_greater_than(0) }
  
  # Test uniqueness manually since shoulda-matchers has issues with NOT NULL constraints
  describe '#name' do
    let!(:existing_reward) { create(:reward, name: 'Coffee Reward') }
    
    it 'prevents duplicate names' do
      duplicate_reward = build(:reward, name: 'Coffee Reward')
      expect(duplicate_reward).not_to be_valid
      expect(duplicate_reward.errors[:name]).to include('has already been taken')
    end
    
    it 'prevents case insensitive duplicates' do
      duplicate_reward = build(:reward, name: 'COFFEE REWARD')
      expect(duplicate_reward).not_to be_valid
      expect(duplicate_reward.errors[:name]).to include('has already been taken')
    end

    describe 'with database constraints' do
      it 'enforces name uniqueness' do
        expect {
          Reward.connection.execute("INSERT INTO rewards (name, points, created_at, updated_at) VALUES ('Coffee Reward', 200, '#{Time.current}', '#{Time.current}')")
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end
end
