require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user, email_address: "test@example.com", points_balance: 1000) }
  let(:session) { create(:session, user: user) }
  let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }

  describe "GET /api/v1/user" do
    context "when authenticated" do
      it "returns current user details" do
        get "/api/v1/user", headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(response.parsed_body).to include(
            "email_address" => "test@example.com",
            "nanoid" => user.nanoid,
            "points_balance" => 1000
          )
        end
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        get "/api/v1/user"

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        get "/api/v1/user"

        expect(response.parsed_body["error"]).to eq("unauthorized")
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        get "/api/v1/user", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PATCH /api/v1/user" do
    context "when authenticated" do
      it "updates the user email" do
        patch "/api/v1/user", params: { email_address: "newemail@example.com" }, headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(user.reload.email_address).to eq("newemail@example.com")
        end
      end

      it "normalizes email address" do
        patch "/api/v1/user", params: { email_address: "  NEWEMAIL@EXAMPLE.COM  " }, headers: auth_headers

        aggregate_failures do
          expect(response).to have_http_status(:ok)
          expect(user.reload.email_address).to eq("newemail@example.com")
        end
      end

      it "returns updated user details" do
        patch "/api/v1/user", params: { email_address: "newemail@example.com" }, headers: auth_headers

        expect(response.parsed_body).to include(
          "email_address" => "newemail@example.com",
          "nanoid" => user.nanoid,
          "points_balance" => 1000
        )
      end

      context "with duplicate email" do
        before { create(:user, email_address: "existing@example.com") }

        it "returns unprocessable entity status" do
          patch "/api/v1/user", params: { email_address: "existing@example.com" }, headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "returns error details" do
          patch "/api/v1/user", params: { email_address: "existing@example.com" }, headers: auth_headers

          aggregate_failures do
            expect(response.parsed_body["error"]).to eq("unprocessable_entity")
            expect(response.parsed_body["details"]).to include("Email address has already been taken")
          end
        end
      end

      context "with invalid email format" do
        it "accepts any email format (no format validation)" do
          patch "/api/v1/user", params: { email_address: "invalid-email" }, headers: auth_headers

          aggregate_failures do
            expect(response).to have_http_status(:ok)
            expect(user.reload.email_address).to eq("invalid-email")
          end
        end
      end

      context "with empty email" do
        it "returns unprocessable entity status" do
          patch "/api/v1/user", params: { email_address: "" }, headers: auth_headers

          expect(response).to have_http_status(:unprocessable_entity)
        end
      end

      context "with no parameters" do
        it "returns ok status (no changes)" do
          patch "/api/v1/user", headers: auth_headers

          expect(response).to have_http_status(:ok)
        end
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        patch "/api/v1/user", params: { email_address: "newemail@example.com" }

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        patch "/api/v1/user", params: { email_address: "newemail@example.com" }, headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
