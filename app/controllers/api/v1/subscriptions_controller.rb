# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      def create
        subscription = SubscriptionServices::Purchase.new(create_params).call
        render json: subscription
      end

      private

      def create_params
        {
          plan_id: params.require(:plan_id),
          customer_id: params.require(:customer_id),
          customer_params: params.require(:customer).permit(:id, :name, :address, :zip_code).to_h,
          payment_params: params.require(:payment)
                                .permit(:card_number, :expiration_date, :cvv, :zip_code).to_h
        }
      end
    end
  end
end
