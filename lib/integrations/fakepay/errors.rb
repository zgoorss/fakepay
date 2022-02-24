# frozen_string_literal: true

module Integrations
  module Fakepay
    class Errors
      InvalidCreditCardNumber = Class.new(StandardError)
      InsufficientFunds = Class.new(StandardError)
      CvvFailure = Class.new(StandardError)
      ExpiredCard = Class.new(StandardError)
      InvalidZipCode = Class.new(StandardError)
      InvalidPurchaseAmount = Class.new(StandardError)
      InvalidToken = Class.new(StandardError)
      InvalidParams = Class.new(StandardError)
      ServiceUnavailable = Class.new(StandardError)
    end
  end
end
