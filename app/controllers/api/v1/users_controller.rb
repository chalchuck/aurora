# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      def create
        onboard_user = OnboardUser.call(user_params)

        if onboard_user.success?
          render json: onboard_user.result, status: :created # the metrics will be returned here alongside the JSON payload
        else
          render json: onboard_user, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:first_name, :last_name, :email, :password)
      end
    end
  end
end
