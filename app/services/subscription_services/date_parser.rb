# frozen_string_literal: true

module SubscriptionServices
  class DateParser
    def initialize(date:)
      @date = date
    end

    def year
      parsed_date.strftime('%Y')
    end

    def month
      parsed_date.strftime('%m')
    end

    private

    attr_reader :date

    def parsed_date
      @parsed_date ||= Date.parse(date)
    end
  end
end
