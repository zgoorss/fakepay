# frozen_string_literal: true

require 'rails_helper'

describe Customer, type: :model do
  let(:customer) { create(:customer) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:zip_code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:subscriptions) }
    it { is_expected.to have_many(:payments) }
  end

  describe '#last_payment_token' do
    subject(:last_payment_token) { customer.last_payment_token }

    context 'with payments' do
      let(:payment) { build :payment }

      before do
        subscription = build :subscription, customer: customer
        subscription.payments << payment
        subscription.save
      end

      it 'returns last payment token' do
        expect(last_payment_token).to eq(payment.token)
      end
    end

    context 'with no payments' do
      it { is_expected.to be_nil }
    end
  end
end
