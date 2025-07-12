require 'rails_helper'

RSpec.describe User, type: :model do
  # Shoulda-matchers shorthand for validations
  it { should validate_presence_of(:password) }
  it { should have_secure_password }
  it { should have_many(:sessions).dependent(:destroy) }

  # Test email presence manually since shoulda-matchers has issues with multiple validations
  describe '#email_address' do
    it 'requires email address' do
      user = build(:user, email_address: nil)
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it 'normalizes to lowercase' do
      user = create(:user, email_address: '  TEST@EXAMPLE.COM  ')
      expect(user.email_address).to eq('test@example.com')
    end

    it 'strips whitespace' do
      user = create(:user, email_address: '  test@example.com  ')
      expect(user.email_address).to eq('test@example.com')
    end

    context "with a duplicate email" do
      let!(:existing_user) { create(:user, email_address: 'test@example.com') }

      it 'prevents duplicate email addresses' do
        duplicate_user = build(:user, email_address: 'test@example.com')
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email_address]).to include('has already been taken')
      end

      it 'prevents case insensitive duplicates' do
        duplicate_user = build(:user, email_address: 'TEST@EXAMPLE.COM')
        expect(duplicate_user).not_to be_valid
        expect(duplicate_user.errors[:email_address]).to include('has already been taken')
      end
    end

    describe 'with database constraints' do
      it 'enforces email uniqueness' do
        create(:user, email_address: 'test@example.com')
        expect {
          User.connection.execute("INSERT INTO users (email_address, password_digest, created_at, updated_at) VALUES ('test@example.com', 'digest', '#{Time.current}', '#{Time.current}')")
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe '#password' do
    it 'requires password on creation' do
      user = build(:user, password: nil)
      expect(user).not_to be_valid
      expect(user.errors[:password]).to include("can't be blank")
    end

    it 'allows password update without current password' do
      user = create(:user)
      user.password = 'new_password'
      user.password_confirmation = 'new_password'
      expect(user).to be_valid
    end

    it 'validates password confirmation' do
      user = build(:user, password: 'password123', password_confirmation: 'different')
      expect(user).not_to be_valid
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  describe 'sessions association' do
    let(:user) { create(:user) }

    it 'destroys sessions when user is destroyed' do
      session = user.sessions.create!(user_agent: 'Browser', ip_address: '192.168.1.1')
      user.destroy

      expect(Session.exists?(session.id)).to be false
    end
  end
end
