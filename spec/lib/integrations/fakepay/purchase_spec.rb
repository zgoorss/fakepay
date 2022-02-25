# frozen_string_literal: true

require 'rails_helper'

describe Integrations::Fakepay::Purchase do
  subject(:purchase) { described_class.new(amount: amount, payment_params: payment_params) }

  let(:amount) { 1000 }
  let(:payment_params) { { data: {} } }

  describe '#body' do
    let(:client_params) do
      {
        url: 'https://www.fakepay.io/purchase',
        params: {
          amount: amount,
          **payment_params
        }
      }
    end
    let(:client_double) { instance_double(Integrations::Fakepay::Client, call: client_response) }
    let(:client_response) { OpenStruct.new(status: response_status, body: response_body) }

    before do
      allow(Integrations::Fakepay::Client).to receive(:new)
        .with(client_params).and_return(client_double)
    end

    context 'when client status is 200' do
      let(:response_status) { 200 }
      let(:response_body) { true }

      it 'returns body' do
        expect(purchase.body).to eq(response_body)
      end
    end

    context 'when client status is 422' do
      let(:response_status) { 422 }

      described_class::AVAILABLE_ERRORS.each do |error_code, error|
        context "when body includes error_code=#{error_code}" do
          let(:response_body) { { 'error_code' => error_code } }

          it "raises #{error}" do
            expect { purchase.body }.to raise_error(error)
          end
        end
      end
    end

    context 'when client status is other than 200 and 422' do
      let(:response_status) { 503 }
      let(:response_body) { '' }

      it 'raises ServiceUnavailable' do
        expect { purchase.body }.to raise_error(Integrations::Fakepay::Errors::ServiceUnavailable)
      end
    end
  end
end
