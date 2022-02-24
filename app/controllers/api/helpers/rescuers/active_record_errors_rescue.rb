# frozen_string_literal: true

module Api
  module Helpers
    module Rescuers
      module ActiveRecordErrorsRescue
        extend ActiveSupport::Concern

        ERROR_MESSAGES = {
          record_not_found: 'Record not found',
          record_invalid: 'Invalid record'
        }.freeze

        included do
          rescue_from ActiveRecord::RecordNotFound do |error|
            render json: {
              title: ERROR_MESSAGES.fetch(:record_not_found),
              status: 404,
              error: error
            }
          end

          rescue_from ActiveRecord::RecordInvalid do |error|
            render json: {
              title: ERROR_MESSAGES.fetch(:record_invalid),
              status: 422,
              error: error,
              detail: error.message
            }
          end
        end
      end
    end
  end
end
