require "rails_helper"

RSpec.describe RedeemReward do
  subject(:redemption) { described_class.new(user, reward).call }

  let(:user) { create(:user, points_balance: 1000) }
  let(:reward) { create(:reward, points: 500) }


  describe "#call" do
    context "when user has sufficient points" do
      it "creates a redemption" do
        expect { described_class.new(user, reward).call }.to change(Redemption, :count).by(1)
      end

      it "updates the user's points balance" do
        expect { described_class.new(user, reward).call }.to change { user.reload.points_balance }.by(-500)
      end

      it "returns a persisted redemption with correct attributes" do
        result = redemption
        expect(result).to be_a(Redemption)
        expect(result).to be_persisted
        expect(result.user).to eq(user)
        expect(result.reward).to eq(reward)
        expect(result.points_cost).to eq(reward.points)
      end
    end

    context "when user has exactly enough points" do
      let(:user) { create(:user, points_balance: 500) }
      let(:reward) { create(:reward, points: 500) }

      it "sets the user's points balance to zero" do
        expect { described_class.new(user, reward).call }.to change { user.reload.points_balance }.to(0)
      end
    end

    context "when user has insufficient points" do
      let(:user) { create(:user, points_balance: 300) }
      let(:reward) { create(:reward, points: 500) }

      it "raises ActiveRecord::RecordInvalid" do
        expect { redemption }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "does not create a redemption" do
        expect {
          begin
            redemption
          rescue ActiveRecord::RecordInvalid
          end
        }.not_to change(Redemption, :count)
      end

      it "does not update user points" do
        original_points = user.points_balance
        begin
          redemption
        rescue ActiveRecord::RecordInvalid
        end
        expect(user.reload.points_balance).to eq(original_points)
      end
    end

    context "when user has negative points after redemption" do
      let(:user) { create(:user, points_balance: 100) }
      let(:reward) { create(:reward, points: 200) }

      it "raises ActiveRecord::RecordInvalid" do
        expect { redemption }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when user has zero points" do
      let(:user) { create(:user, points_balance: 0) }
      let(:reward) { create(:reward, points: 100) }

      it "raises ActiveRecord::RecordInvalid" do
        expect { redemption }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context "when user update fails" do
      before do
        allow(user).to receive(:update!).and_raise(ActiveRecord::RecordInvalid.new(user))
      end

      it "does not create redemption" do
        expect {
          begin
            redemption
          rescue ActiveRecord::RecordInvalid
          end
        }.not_to change(Redemption, :count)
      end
    end
  end
end
