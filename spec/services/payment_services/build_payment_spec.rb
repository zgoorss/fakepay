# frozen_string_literal: true

require 'rails_helper'

describe PaymentServices::BuildPayment do
  subject(:build_payment) { described_class.new(amount: amount, payment_params: payment_params) }

  let(:amount) { 1000 }
  let(:payment_params) { {} }

  describe '#call' do
    let(:purchase_response) do
      {
        'token' => 'token'
      }
    end

    before do
      fakepay_purchase_double = instance_double(Integrations::Fakepay::Purchase,
                                                body: purchase_response)
      allow(Integrations::Fakepay::Purchase).to receive(:new).and_return(fakepay_purchase_double)
    end

    it 'build payment with expected attributes' do
      payment = build_payment.call

      expect(payment.amount).to eq(amount)
      expect(payment.token).to eq(purchase_response['token'])
    end
  end
end
