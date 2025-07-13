require "rails_helper"

RSpec.describe "Api::V1::Rewards", type: :request do
  let!(:reward1) { create(:reward, name: "Coffee Reward", points: 500) }
  let!(:reward2) { create(:reward, name: "Lunch Reward", points: 1000) }
  let!(:reward3) { create(:reward, name: "Movie Ticket", points: 1500) }

  describe "GET /api/v1/rewards" do
    context "when not authenticated" do
      it "returns all rewards" do
        get "/api/v1/rewards"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.length).to eq(3)

          reward_names = response.parsed_body.map { |r| r["name"] }
          expect(reward_names).to include("Coffee Reward", "Lunch Reward", "Movie Ticket")
        end
      end

      it "returns rewards in summary format" do
        get "/api/v1/rewards"

        first_reward = response.parsed_body.first

        aggregate_failures do
          expect(first_reward["nanoid"]).to be_present
          expect(first_reward["name"]).to be_present
          expect(first_reward["points"]).to be_present
        end
      end

      it "returns empty array when no rewards exist" do
        Reward.destroy_all
        get "/api/v1/rewards"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to eq([])
        end
      end
    end

    context "when authenticated" do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }

      it "returns all rewards" do
        get "/api/v1/rewards", headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.length).to eq(3)
        end
      end
    end
  end

  describe "GET /api/v1/rewards/:id" do
    context "with valid nanoid" do
      it "returns the specific reward" do
        get "/api/v1/rewards/#{reward1.nanoid}"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["nanoid"]).to eq(reward1.nanoid)
          expect(response.parsed_body["name"]).to eq("Coffee Reward")
          expect(response.parsed_body["points"]).to eq(500)
        end
      end

      it "returns reward in detail format" do
        get "/api/v1/rewards/#{reward1.nanoid}"

        reward = response.parsed_body

        aggregate_failures do
          expect(reward["nanoid"]).to be_present
          expect(reward["name"]).to be_present
          expect(reward["points"]).to be_present
        end
      end
    end

    context "with invalid nanoid" do
      it "returns not found status" do
        get "/api/v1/rewards/invalid_nanoid"

        expect(response).to have_http_status(:not_found)
      end

      it "returns error message" do
        get "/api/v1/rewards/invalid_nanoid"

        expect(response.parsed_body["error"]).to eq("not_found")
      end
    end

    context "with non-existent nanoid" do
      it "returns not found status" do
        get "/api/v1/rewards/#{SecureRandom.alphanumeric(21)}"

        expect(response).to have_http_status(:not_found)
      end
    end

    context "when not authenticated" do
      it "returns the reward" do
        get "/api/v1/rewards/#{reward1.nanoid}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when authenticated" do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }

      it "returns the reward" do
        get "/api/v1/rewards/#{reward1.nanoid}", headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
