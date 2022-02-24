# frozen_string_literal: true

module SubscriptionServices
  class Renew
    def initialize(subscription:)
      @subscription = subscription
    end

    def call
      ActiveRecord::Base.transaction do
        subscription.payments << build_payment
        subscription.assign_attributes(active: true, expires_at: subscription.new_expires_at_date)
        subscription.save
      rescue Integrations::Fakepay::Errors::ServiceUnavailable,
             *Integrations::Fakepay::Purchase::AVAILABLE_ERRORS.values => _e
        # service to log error
        false
      end
    end

    private

    attr_reader :subscription

    delegate :plan, :customer, to: :subscription

    def build_payment
      @build_payment ||= PaymentServices::BuildPayment.new(
        amount: plan.price_in_cents,
        payment_params: {
          token: customer.last_payment_token
        }
      ).call
    end
  end
end
