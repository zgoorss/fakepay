# frozen_string_literal: true

require 'rails_helper'

describe SubscriptionServices::Purchase do
  subject(:purchase) do
    described_class.new(
      plan_id: plan.id,
      customer_id: customer.id,
      customer_params: customer_params,
      payment_params: payment_params
    )
  end

  let(:plan) { create(:plan) }
  let(:customer) { create(:customer) }
  let(:customer_params) { {} }
  let(:payment_params) do
    {
      card_number: '',
      cvv: '',
      expiration_date: '02/2022',
      zip_code: ''
    }
  end
  let(:build_payment_params) do
    {
      card_number: '',
      cvv: '',
      expiration_month: '02',
      expiration_year: '2022',
      zip_code: ''
    }
  end

  describe '#call' do
    let(:payment) { build(:payment) }

    before do
      build_payment = double
      allow(PaymentServices::BuildPayment).to receive(:new)
        .with(amount: plan.price_in_cents, payment_params: build_payment_params)
        .and_return(build_payment)
      allow(build_payment).to receive(:call).and_return(payment)
    end

    context 'when customer already exists' do
      before { customer }

      it 'does not create new one' do
        expect { purchase.call }.not_to change(Customer, :count)
      end
    end

    context 'when customer does not exist' do
      it 'creates new one' do
        expect { purchase.call }.to change(Customer, :count).by(1)
      end
    end

    context 'when subscription already exists' do
      before { create(:subscription, plan: plan, customer: customer) }

      it 'raises SubscriptionExists' do
        expect { purchase.call }.to raise_error(described_class::SubscriptionExists)
      end
    end

    context 'when subscription does not exist' do
      it 'creates subscription' do
        expect { purchase.call }.to change(Subscription, :count).by(1)
      end

      it 'creates payment' do
        expect { purchase.call }.to change(Payment, :count).by(1)
      end
    end
  end
end
