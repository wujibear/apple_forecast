require "rails_helper"

RSpec.describe "Api::V1::Rewards", type: :request do
  describe "GET /api/v1/rewards" do
    before do
      create_list(:reward, 3)
    end

    context "when not authenticated" do
      it "returns all rewards" do
        get "/api/v1/rewards"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body.length).to eq(3)

          returned_names = response.parsed_body.map { |r| r["name"] }
          existing_names = Reward.pluck(:name)
          expect(returned_names).to match_array(existing_names)
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
    let(:reward) { create(:reward) }

    context "with valid nanoid" do
      it "returns the specific reward" do
        get "/api/v1/rewards/#{reward.nanoid}"

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body["nanoid"]).to eq(reward.nanoid)
          expect(response.parsed_body["name"]).to eq(reward.name)
          expect(response.parsed_body["points"]).to eq(reward.points)
        end
      end
    end

    context "with invalid nanoid" do
      it "returns not found status" do
        get "/api/v1/rewards/invalid_nanoid"

        aggregate_failures do
          expect(response).to have_http_status(:not_found)
          expect(response.parsed_body["error"]).to eq("not_found")
        end
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
        get "/api/v1/rewards/#{reward.nanoid}"

        expect(response).to have_http_status(:ok)
      end
    end

    context "when authenticated" do
      let(:user) { create(:user) }
      let(:session) { create(:session, user: user) }
      let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }

      it "returns the reward" do
        get "/api/v1/rewards/#{reward.nanoid}", headers: auth_headers

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
