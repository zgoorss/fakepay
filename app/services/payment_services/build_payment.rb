# frozen_string_literal: true

module PaymentServices
  class BuildPayment
    def initialize(amount:, payment_params:)
      @amount = amount
      @payment_params = payment_params
    end

    def call
      Payment.new(
        token: fakepay_payment.body['token'],
        amount: amount
      )
    end

    private

    attr_reader :amount, :payment_params

    def fakepay_payment
      @fakepay_payment ||= Integrations::Fakepay::Purchase.new(
        amount: amount,
        payment_params: payment_params
      )
    end
  end
end
