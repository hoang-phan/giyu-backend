module Api
  module V1
    class FlavorsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(flavor: %i[name unit_price])
      end
    end
  end
end
