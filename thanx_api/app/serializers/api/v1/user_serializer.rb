module Api
  module V1
    class UserSerializer < BaseSerializer
      identifier :id

      view :summary do
        fields :email_address
      end

      view :detail do
        include_view :summary

        association :sessions, blueprint: SessionSerializer
        association :redemptions, blueprint: RedemptionSerializer
        association :rewards, blueprint: RewardSerializer
      end
    end
  end
end
