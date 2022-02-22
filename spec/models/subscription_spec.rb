# frozen_string_literal: true

require 'rails_helper'

describe Subscription, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:expires_at) }
    it { is_expected.to validate_presence_of(:active) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:customer) }
    it { is_expected.to belong_to(:plan) }
  end
end