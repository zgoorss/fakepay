# frozen_string_literal: true

module Api
  module V1
    class SubscriptionsController < ApplicationController
      include Api::Helpers::Rescuers::FakepayErrorsRescue
      include Api::Helpers::Rescuers::SubscriptionErrorsRescue

      def create
        subscription = SubscriptionServices::Purchase.new(create_params).call
        render json: { subscription: subscription, customer: subscription.customer }, status: 201
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
