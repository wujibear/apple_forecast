module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication!
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication!, **options
    end
  end

  private

  def authenticated?
    current_session.present?
  end

  def require_authentication!
    # raise unauthenticated error and rescue from with error response
    current_session || unauthorized!
  end

  def current_session
    Current.session ||= find_session_by_token_or_session_id
  end

  def current_user
    @current_user ||= current_session.user
  end

  def find_session_by_token_or_session_id
    token = extracted_bearer_token
    return unless token

    # Try to find session by secure token first
    session = Session.find_by(token: token)
    return session if session

    # Fallback: Try JWT token (for backward compatibility)
    payload = JwtService.decode(token)
    return unless payload

    session_id = payload["session_id"]
    return unless session_id

    Session.find_by(id: session_id)
  end

  def extracted_bearer_token
    auth_header = request.headers["Authorization"]
    return nil unless auth_header

    # Extract token from "Bearer <token>" format
    auth_header.split(" ").last.presence
  end

  def start_new_session_for(user)
    user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip).tap do |session|
      Current.session = session

      # Return the secure token (not the session ID)
      response.headers["X-Session-Token"] = session.token
    end
  end

  def terminate_session
    Current.session&.destroy
    # Clear any stored session data
    response.headers["X-Session-Token"] = nil
  end

  def unauthorized!
    raise UnauthorizedError, "Authentication required"
  end
end
