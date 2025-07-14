module Api
  module V1
    class RedemptionSerializer < BaseSerializer
      identifier :nanoid

      view :summary do
        fields :points_cost, :reward_name
      end
    end
  end
end
