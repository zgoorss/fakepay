# frozen_string_literal: true

require 'rails_helper'

describe Integrations::Fakepay::Client do
  subject(:client) { described_class.new(url: url, params: {}) }

  let(:url) { 'url' }

  describe '#call' do
    let(:faraday_double) { double }
    let(:generated_api_key) { 'token' }
    let(:connection_params) do
      {
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Token token=#{generated_api_key}"
        }
      }
    end

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with('GENERATED_API_KEY').and_return(generated_api_key)

      allow(Faraday).to receive(:new).with(connection_params).and_return(faraday_double)
      allow(faraday_double).to receive(:post).with(url).and_return(Object)
    end

    it 'initializes client correctly' do
      expect(Faraday).to receive(:new).with(connection_params).and_return(faraday_double)
      client.call
    end

    it 'calls :post to Faraday with provided url' do
      expect(faraday_double).to receive(:post).with(url).once
      client.call
    end
  end
end
