# frozen_string_literal: true

require 'rails_helper'

describe 'POST /api/v1/subscriptions', type: 'request' do
  subject(:call_post) { post '/api/v1/subscriptions', params: post_params }

  let(:plan) { create(:plan) }
  let(:customer) { create(:customer) }
  let(:subscription) { create(:subscription, plan: plan, customer: customer) }

  context 'when params is correct' do
    let(:post_params) do
      {
        plan_id: plan.id,
        customer_id: customer.id,
        customer: { name: nil, address: nil, zip_code: nil },
        payment: { card_number: nil, expiration_date: nil, cvv: nil, zip_code: nil }
      }
    end
    let(:purchase_double) { double }

    context 'when process is completed successfully' do
      before do
        allow(SubscriptionServices::Purchase).to receive(:new).and_return(purchase_double)
        allow(purchase_double).to receive(:call).and_return(subscription)
      end

      it 'calls SubscriptionServices::Purchase' do
        expect(purchase_double).to receive(:call).once
        call_post
      end

      it 'returns 201 with correct data' do
        expected_response = { subscription: subscription, customer: customer }.to_json

        call_post
        expect(response.status).to eq(201)
        expect(response.body).to eq(expected_response)
      end
    end

    context 'when process returns error' do
      before do
        allow(SubscriptionServices::Purchase).to receive(:new).and_return(purchase_double)
        allow(purchase_double).to receive(:call).and_raise(error)
      end

      let(:expected_response) do
        {
          title: title,
          error: underscored_error
        }.to_json
      end

      context 'when InvalidCreditCardNumber is raised' do
        let(:error) { Integrations::Fakepay::Errors::InvalidCreditCardNumber }
        let(:title) { 'Invalid credit card number' }
        let(:underscored_error) { 'invalid_credit_card_number' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when InsufficientFunds is raised' do
        let(:error) { Integrations::Fakepay::Errors::InsufficientFunds }
        let(:title) { 'Insufficient funds' }
        let(:underscored_error) { 'insufficient_funds' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when CvvFailure is raised' do
        let(:error) { Integrations::Fakepay::Errors::CvvFailure }
        let(:title) { 'CVV failure' }
        let(:underscored_error) { 'cvv_failure' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when ExpiredCard is raised' do
        let(:error) { Integrations::Fakepay::Errors::ExpiredCard }
        let(:title) { 'Expired card' }
        let(:underscored_error) { 'expired_card' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when InvalidZipCode is raised' do
        let(:error) { Integrations::Fakepay::Errors::InvalidZipCode }
        let(:title) { 'Invalid zip code' }
        let(:underscored_error) { 'invalid_zip_code' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when InvalidPurchaseAmount is raised' do
        let(:error) { Integrations::Fakepay::Errors::InvalidPurchaseAmount }
        let(:title) { 'Invalid purchase amount' }
        let(:underscored_error) { 'invalid_purchase_amount' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when InvalidToken is raised' do
        let(:error) { Integrations::Fakepay::Errors::InvalidToken }
        let(:title) { 'Invalid token' }
        let(:underscored_error) { 'invalid_token' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when InvalidParams is raised' do
        let(:error) { Integrations::Fakepay::Errors::InvalidParams }
        let(:title) { 'Invalid params: cannot specify both token and other credit card params' }
        let(:underscored_error) { 'invalid_params' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when SubscriptionExists is raised' do
        let(:error) { SubscriptionServices::Purchase::SubscriptionExists }
        let(:title) { 'Subscription already exists for the customer' }
        let(:underscored_error) { 'subscription_exists' }

        it 'returns 422 with error message' do
          call_post
          expect(response.status).to eq(422)
          expect(response.body).to eq(expected_response)
        end
      end

      context 'when ServiceUnavailable is raised' do
        let(:error) { Integrations::Fakepay::Errors::ServiceUnavailable }
        let(:title) { 'Service Unavailable' }
        let(:underscored_error) { 'service_unavailable' }

        it 'returns 503 with error message' do
          call_post
          expect(response.status).to eq(503)
          expect(response.body).to eq(expected_response)
        end
      end
    end
  end

  context 'when params is incorrect' do
    let(:post_params) { {} }

    it 'returns 400 with error message' do
      expected_response = { title: 'Bad request',
                            error: 'param is missing or the value is empty: plan_id' }.to_json

      call_post
      expect(response.status).to eq(400)
      expect(response.body).to eq(expected_response)
    end
  end
end
