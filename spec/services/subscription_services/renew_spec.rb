# frozen_string_literal: true

require 'rails_helper'

describe SubscriptionServices::Renew do
  subject(:renew) { described_class.new(subscription: subscription) }

  let(:subscription) { create(:subscription, active: false, expires_at: expires_at) }
  let(:expires_at) { 1.day.ago }
  let(:payment) { build(:payment) }

  describe '#call' do
    context 'with successful payment' do
      before do
        build_payment = double
        allow(PaymentServices::BuildPayment).to receive(:new).and_return(build_payment)
        allow(build_payment).to receive(:call).and_return(payment)
      end

      it 'creates payment' do
        expect { renew.call }.to change(Payment, :count).by(1)
      end

      it 'adds payment to subscriptions' do
        renew.call
        expect(subscription.payments.last).to eq(payment)
      end

      it 'activates subscription' do
        renew.call
        expect(subscription.active).to eq(true)
      end

      it 'updates expires_at' do
        renew.call
        expect(subscription.expires_at).to eq(expires_at + 1.month)
      end
    end

    context 'with raised errors' do
      errors = Integrations::Fakepay::Purchase::AVAILABLE_ERRORS.values
      errors << Integrations::Fakepay::Errors::ServiceUnavailable

      errors.each do |error|
        context "when #{error} raised" do
          before do
            build_payment = double
            allow(PaymentServices::BuildPayment).to receive(:new).and_return(build_payment)
            allow(build_payment).to receive(:call).and_raise(error)
          end

          it 'does not update subscription' do
            expect(subscription.payments.last).not_to eq(payment)
            expect(subscription.active).not_to eq(true)
            expect(subscription.expires_at).not_to eq(expires_at + 1.month)
          end
        end
      end
    end
  end
end
