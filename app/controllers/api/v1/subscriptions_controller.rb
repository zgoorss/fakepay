# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      def create
        subscription = SubscriptionServices::Purchase.new(create_params).call
        render json: { status: 201,
                       data: { subscription: subscription, customer: subscription.customer } }
      end

      private

      def create_params
        {
          plan_id: params.require(:plan_id),
          customer_id: params.fetch(:customer_id, nil),
          customer_params: params.fetch(:customer, {}).permit(:name, :address, :zip_code),
          payment_params: params.require(:payment)
                                .permit(:card_number, :expiration_date, :cvv, :zip_code)
        }
      end
    end
  end
end
