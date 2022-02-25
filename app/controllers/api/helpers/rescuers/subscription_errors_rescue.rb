# frozen_string_literal: true

module Api
  module Helpers
    module Rescuers
      module SubscriptionErrorsRescue
        extend ActiveSupport::Concern

        ERROR_MESSAGES = {
          subscription_exists: 'Subscription already exists for the customer'
        }.freeze

        included do
          rescue_from SubscriptionServices::Purchase::SubscriptionExists do
            render json: {
              title: ERROR_MESSAGES.fetch(:subscription_exists),
              error: 'subscription_exists'
            }, status: 422
          end
        end
      end
    end
  end
end
