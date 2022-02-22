# frozen_string_literal: true

require 'rails_helper'

describe Payment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:customer_id) }
    it { is_expected.to validate_presence_of(:token) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
  end
end
