module Api
  module V1
    class RedemptionSerializer < BaseSerializer
      identifier :id

      view :summary do
        fields :points_cost
        association :reward, blueprint: RewardSerializer
      end

      view :detail do
        include_view :summary
        association :user, blueprint: UserSerializer
      end
    end
  end
end 