module Api
  module V1
    class UserSerializer < BaseSerializer
      identifier :nanoid

      view :summary do
        fields :email_address
      end

      view :detail do
        include_view :summary
        fields :points_balance

        association :sessions, blueprint: SessionSerializer
      end
    end
  end
end
