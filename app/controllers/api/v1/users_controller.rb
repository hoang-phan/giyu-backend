module Api
  module V1
    class UsersController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(user: %i[code phone])
      end
    end
  end
end
