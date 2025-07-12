module Api
  module V1
    class SessionSerializer < BaseSerializer
      identifier :id

      view :summary do
        fields :user_agent, :ip_address
      end

      view :detail do
        include_view :summary
        association :user, blueprint: UserSerializer
      end
    end
  end
end 