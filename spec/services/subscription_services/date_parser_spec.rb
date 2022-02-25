# frozen_string_literal: true

require 'rails_helper'

describe SubscriptionServices::DateParser do
  subject(:date_parser) { described_class.new(date: date) }

  let(:date) { '02/2022' }

  describe '#year' do
    it 'return correct year' do
      expect(date_parser.year).to eq('2022')
    end
  end

  describe '#month' do
    it 'return correct month' do
      expect(date_parser.month).to eq('02')
    end
  end
end
