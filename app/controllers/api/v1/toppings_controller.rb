module Api
  module V1
    class ToppingsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(topping: %i[name unit_price])
      end
    end
  end
end
