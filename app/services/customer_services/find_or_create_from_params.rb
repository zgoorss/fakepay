# frozen_string_literal: true

module CustomerServices
  class FindOrCreateFromParams
    def initialize(customer_id: nil, params: nil)
      @customer_id = customer_id
      @params = params
    end

    def call
      if customer_id
        Customer.find_by!(id: customer_id)
      else
        Customer.find_or_create_by!(params.slice(:name, :address, :zip_code))
      end
    end

    private

    attr_reader :customer_id, :params
  end
end
