module Api
  module V1
    class ProductsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(product: %i[type fixed_price])
      end
    end
  end
end
