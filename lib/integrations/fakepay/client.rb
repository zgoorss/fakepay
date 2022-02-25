# frozen_string_literal: true

require 'faraday'

module Integrations
  module Fakepay
    class Client
      def initialize(url:, params:)
        @url = url
        @params = params
      end

      def call
        connection.post(url) do |req|
          req.body = params.to_json
        end
      end

      private

      attr_reader :url, :params

      def connection
        Faraday.new(
          headers: {
            'Content-Type' => 'application/json',
            'Authorization' => "Token token=#{generated_api_key}"
          }
        ) do |f|
          f.request :json
          f.response :json
          f.adapter :net_http
        end
      end

      def generated_api_key
        ENV['GENERATED_API_KEY'] || Rails.application.credentials.generated_api_key!
      end
    end
  end
end
