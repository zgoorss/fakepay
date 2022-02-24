# frozen_string_literal: true

require 'rails_helper'

describe Customer, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:address) }
    it { is_expected.to validate_presence_of(:zip_code) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:subscriptions) }
  end
end
