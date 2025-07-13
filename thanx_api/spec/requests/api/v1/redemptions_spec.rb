require "rails_helper"

RSpec.describe "Api::V1::Redemptions", type: :request do
  let(:user) { create(:user, points_balance: 1000) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }
  let(:reward) { create(:reward, name: "Coffee Reward", points: 500) }

  describe "GET /api/v1/redemptions" do
    context "when authenticated" do
      let!(:redemption1) { create(:redemption, user: user, reward: reward, points_cost: 500) }
      let!(:redemption2) { create(:redemption, user: user, reward: create(:reward, name: "Lunch", points: 1000), points_cost: 1000) }

      it "returns user's redemptions" do
        get "/api/v1/redemptions", headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.length).to eq(2)
        end
      end

      it "returns redemptions in descending order by created_at" do
        get "/api/v1/redemptions", headers: auth_headers

        redemptions = response.parsed_body

        expect(redemptions.first["created_at"]).to be > redemptions.second["created_at"]
      end

      it "returns redemptions in detail format" do
        get "/api/v1/redemptions", headers: auth_headers

        first_redemption = response.parsed_body.first

        aggregate_failures do
          expect(first_redemption["nanoid"]).to be_present
          expect(first_redemption["points_cost"]).to be_present
          expect(first_redemption["reward_name"]).to be_present
        end
      end

      it "returns empty array when user has no redemptions" do
        Redemption.destroy_all
        get "/api/v1/redemptions", headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq([])
        end
      end

      it "does not return other users' redemptions" do
        other_user = create(:user)
        create(:redemption, user: other_user, reward: reward, points_cost: 500)

        get "/api/v1/redemptions", headers: auth_headers

        expect(response.parsed_body.length).to eq(2)
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/api/v1/redemptions"

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        get "/api/v1/redemptions"

        expect(response.parsed_body["error"]).to eq("unauthorized")
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        get "/api/v1/redemptions", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "POST /api/v1/rewards/:id/redeem" do
    context "when authenticated" do
      context "with sufficient points" do
        it "creates a redemption" do
          expect {
            post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers
          }.to change(Redemption, :count).by(1)
        end

        it "updates user's points balance" do
          expect {
            post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers
          }.to change { user.reload.points_balance }.by(-500)
        end

        it "returns created status" do
          post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers

          expect(response).to have_http_status(:created)
        end

        it "returns redemption details" do
          post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers

          aggregate_failures do
            expect(response.parsed_body["nanoid"]).to be_present
            expect(response.parsed_body["points_cost"]).to eq(500)
            expect(response.parsed_body["reward_name"]).to eq("Coffee Reward")
          end
        end
      end

      context "with insufficient points" do
        let(:user) { create(:user, points_balance: 300) }

        it "returns unprocessable entity status" do
          post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "does not create a redemption" do
          expect {
            post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers
          }.not_to change(Redemption, :count)
        end

        it "does not update user's points balance" do
          expect {
            post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers
          }.not_to change { user.reload.points_balance }
        end
      end

      context "with exactly enough points" do
        let(:user) { create(:user, points_balance: 500) }

        it "creates a redemption and sets balance to zero" do
          post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: auth_headers

          aggregate_failures do
            expect(response).to have_http_status(:created)
            expect(user.reload.points_balance).to eq(0)
          end
        end
      end

      context "with invalid reward nanoid" do
        it "returns not found status" do
          post "/api/v1/rewards/invalid_nanoid/redeem", headers: auth_headers

          expect(response).to have_http_status(:not_found)
        end
      end

      context "with non-existent reward" do
        it "returns not found status" do
          post "/api/v1/rewards/#{SecureRandom.alphanumeric(21)}/redeem", headers: auth_headers

          expect(response).to have_http_status(:not_found)
        end
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        post "/api/v1/rewards/#{reward.nanoid}/redeem"

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        post "/api/v1/rewards/#{reward.nanoid}/redeem", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
