# frozen_string_literal: true

module Integrations
  module Fakepay
    class Purchase
      CONNECTION_URL = 'https://www.fakepay.io/purchase'
      AVAILABLE_ERRORS = {
        1000001 => Errors::InvalidCreditCardNumber,
        1000002 => Errors::InsufficientFunds,
        1000003 => Errors::CvvFailure,
        1000004 => Errors::ExpiredCard,
        1000005 => Errors::InvalidZipCode,
        1000006 => Errors::InvalidPurchaseAmount,
        1000007 => Errors::InvalidToken,
        1000008 => Errors::InvalidParams
      }.freeze

      def initialize(amount:, payment_params:)
        @amount = amount
        @payment_params = payment_params
      end

      def body
        case client.status
        when 200 then client.body
        when 422
          error_code = client.body.fetch('error_code')
          raise AVAILABLE_ERRORS.fetch(error_code)
        else
          raise Errors::ServiceUnavailable
        end
      end

      private

      attr_reader :amount, :payment_params

      def client
        @client ||= begin
          Client.new(
            url: CONNECTION_URL,
            params: {
              amount: amount,
              **payment_params
            }
          ).call
        end
      end
    end
  end
end
