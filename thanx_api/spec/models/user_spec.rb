require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to have_secure_password }
  it { is_expected.to have_many(:sessions).dependent(:destroy) }
  it { is_expected.to have_many(:redemptions).dependent(:destroy) }
  it { is_expected.to have_many(:rewards).through(:redemptions) }

  # Test email presence manually since shoulda-matchers have issues with multiple validations
  describe '#email_address' do
    it 'requires email address' do
      user = build(:user, email_address: nil)

      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors[:email_address]).to include("can't be blank")
      end
    end

    it 'normalizes and strips email address' do
      user = create(:user, email_address: '  TeSt@ExAmPLe.COM  ')
      expect(user.email_address).to eq('test@example.com')
    end

    context "with a duplicate email" do
      before do
        create(:user, email_address: 'test@example.com')
      end

      it 'prevents a second email' do
        duplicate_user = build(:user, email_address: 'test@example.com')

        aggregate_failures do
          expect(duplicate_user).not_to be_valid
          expect(duplicate_user.errors[:email_address]).to include('has already been taken')
        end
      end
    end

    describe 'with database constraints' do
      it 'enforces email uniqueness' do
        create(:user, email_address: 'test@example.com')
        expect {
          described_class.connection.execute("INSERT INTO users (email_address, password_digest, created_at, updated_at) VALUES ('test@example.com', 'digest', '#{Time.current}', '#{Time.current}')")
        }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end
  end

  describe '#password' do
    it 'requires password on creation' do
      user = build(:user, password: nil)

      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors[:password]).to include("can't be blank")
      end
    end

    it 'allows password update without current password' do
      user = create(:user)
      user.password = 'new_password'
      user.password_confirmation = 'new_password'
      expect(user).to be_valid
    end

    it 'validates password confirmation mismatch' do
      user = build(:user, password: 'password123', password_confirmation: 'different')

      aggregate_failures do
        expect(user).not_to be_valid
        expect(user.errors[:password_confirmation]).to include("doesn't match Password")
      end
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
