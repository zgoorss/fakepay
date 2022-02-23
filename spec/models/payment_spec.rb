# frozen_string_literal: true

require 'rails_helper'

describe Payment, type: :model do
  describe 'validations' do
    let(:statuses) { { completed: 0, failed: 1 } }

    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_presence_of(:status) }
    it { is_expected.to validate_presence_of(:payload) }

    it { is_expected.to define_enum_for(:status).with_values(statuses) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:subscription) }
  end
end
