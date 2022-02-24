# frozen_string_literal: true

module Api
  module Helpers
    module Rescuers
      module FakepayErrorsRescue
        extend ActiveSupport::Concern

        ERROR_MESSAGES = {
          invalid_credit_card_number: 'Invalid credit card number',
          insufficient_funds: 'Insufficient funds',
          cvv_failure: 'CVV failure',
          expired_card: 'Expired card',
          invalid_zip_code: 'Invalid zip code',
          invalid_purchase_amount: 'Invalid purchase amount',
          invalid_token: 'Invalid token',
          invalid_params: 'Invalid params: cannot specify both token and other credit card params',
          service_unavailable: 'Service Unavailable'
        }.freeze

        included do
          rescue_from *Integrations::Fakepay::Purchase::AVAILABLE_ERRORS.values do |error|
            underscored_error = error.class.name.demodulize.underscore.to_sym
            render json: {
              title: ERROR_MESSAGES.fetch(underscored_error),
              status: 422,
              error: underscored_error
            }
          end

          rescue_from Integrations::Fakepay::Errors::ServiceUnavailable do |error|
            render json: {
              title: ERROR_MESSAGES.fetch(:service_unavailable),
              status: 503,
              error: error.class.name.demodulize.underscore
            }
          end
        end
      end
    end
  end
end
