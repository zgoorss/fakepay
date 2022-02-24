# frozen_string_literal: true

require 'rails_helper'

describe Subscription, type: :model do
  let(:subscription) { create(:subscription) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:expires_at) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:plan) }
    it { is_expected.to have_many(:payments) }
  end

  describe '#new_expires_at_date' do
    subject(:new_expires_at_date) { subscription.new_expires_at_date }

    context 'when expires_at is today' do
      before { subscription.expires_at = Date.today }

      it 'extends expires_at by 1 month' do
        expect(new_expires_at_date).to eq(Date.today + 1.month)
      end
    end
  end
end
