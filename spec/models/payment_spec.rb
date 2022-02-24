# frozen_string_literal: true

require 'rails_helper'

describe Payment, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:subscription) }
  end
end
