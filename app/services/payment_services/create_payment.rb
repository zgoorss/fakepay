# frozen_string_literal: true

module PaymentServices
  class CreatePayment
    PaymentFailed = Class.new(StandardError)

    def initialize(amount:, payment_params:)
      @amount = amount
      @payment_params = payment_params
    end

    def call
      return create_payment if payment_successful?

      raise PaymentFailed, fakapay_purchase
    end

    private

    attr_reader :amount, :payment_params

    def create_payment
      Payment.create!(
        token: fakapay_purchase['token'],
        status: payment_status,
        amount: amount,
        payload: fakapay_purchase
      )
    end

    def fakapay_purchase
      @fakapay_purchase ||= Integrations::Fakepay::Purchase.new(
        amount: amount,
        **payment_params
      ).call
    end

    def payment_status
      payment_successful? ? :completed : :failed
    end

    def payment_successful?
      fakapay_purchase['success'].to_s == 'true'
    end
  end
end
