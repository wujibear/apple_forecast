require "rails_helper"

RSpec.describe "Api::V1::Sessions", type: :request do
  let!(:user) { create(:user, email_address: "test@example.com", password: "password123") }
  let(:valid_credentials) { { email_address: "test@example.com", password: "password123" } }
  let(:invalid_credentials) { { email_address: "test@example.com", password: "wrongpassword" } }

  describe "POST /api/v1/session" do
    context "with valid credentials" do
      it "creates a new session and returns user details" do
        post "/api/v1/session", params: valid_credentials

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response["email_address"]).to eq("test@example.com")
        expect(json_response["nanoid"]).to be_present
        expect(json_response["points_balance"]).to eq(0)
        expect(json_response["password_digest"]).to be_nil
      end

      it "creates a session record" do
        expect {
          post "/api/v1/session", params: valid_credentials
        }.to change(Session, :count).by(1)
      end

      it "normalizes email address" do
        post "/api/v1/session", params: { email_address: "  TEST@EXAMPLE.COM  ", password: "password123" }

        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid credentials" do
      it "returns unprocessable entity status" do
        post "/api/v1/session", params: invalid_credentials

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        post "/api/v1/session", params: invalid_credentials

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("unauthorized")
        expect(json_response["message"]).to eq("Authentication required")
      end

      it "does not create a session" do
        expect {
          post "/api/v1/session", params: invalid_credentials
        }.not_to change(Session, :count)
      end
    end

    context "with missing parameters" do
      it "returns bad request for missing email" do
        post "/api/v1/session", params: { password: "password123" }

        expect(response).to have_http_status(:bad_request)
      end

      it "returns bad request for missing password" do
        post "/api/v1/session", params: { email_address: "test@example.com" }

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "with non-existent user" do
      it "returns unauthorized status" do
        post "/api/v1/session", params: { email_address: "nonexistent@example.com", password: "password123" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "DELETE /api/v1/session" do
    let(:session) { create(:session, user: user) }
    let(:auth_headers) { { "Authorization" => "Bearer #{session.token}" } }

    context "when authenticated" do
      it "terminates the session" do
        delete "/api/v1/session", headers: auth_headers

        expect(response).to have_http_status(:no_content)
        expect(Session.exists?(session.id)).to be false
      end

      it "returns no content status" do
        delete "/api/v1/session", headers: auth_headers

        expect(response).to have_http_status(:no_content)
        expect(response.body).to be_empty
      end
    end

    context "when not authenticated" do
      it "returns unauthorized status" do
        delete "/api/v1/session"

        expect(response).to have_http_status(:unauthorized)
      end

      it "returns error message" do
        delete "/api/v1/session"

        json_response = JSON.parse(response.body)
        expect(json_response["error"]).to eq("unauthorized")
      end
    end

    context "with invalid token" do
      it "returns unauthorized status" do
        delete "/api/v1/session", headers: { "Authorization" => "Bearer invalid_token" }

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
