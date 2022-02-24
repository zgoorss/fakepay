# frozen_string_literal: true

module SubscriptionServices
  class Purchase
    SubscriptionExists = Class.new(StandardError)

    def initialize(plan_id:, customer_id:, customer_params:, payment_params:)
      @plan_id = plan_id
      @customer_id = customer_id
      @customer_params = customer_params
      @payment_params = payment_params
    end

    def call
      ActiveRecord::Base.transaction do
        raise SubscriptionExists if subscription_exists?

        subscription = build_subscription
        subscription.payments << build_payment
        subscription.save!
        subscription
      end
    end

    private

    attr_reader :customer_id, :plan_id, :customer_params, :payment_params

    def subscription_exists?
      Subscription.exists?(customer: customer, plan: plan)
    end

    def plan
      @plan ||= Plan.find(plan_id)
    end

    def customer
      @customer ||= if customer_id.present?
                      Customer.find(customer_id)
                    else
                      Customer.find_or_create_by!(customer_params)
                    end
    end

    def build_payment
      @build_payment ||= PaymentServices::BuildPayment.new(
        amount: plan.price_in_cents,
        payment_params: {
          card_number: payment_params.fetch(:card_number),
          cvv: payment_params.fetch(:cvv),
          expiration_month: parsed_date.month,
          expiration_year: parsed_date.year,
          zip_code: payment_params.fetch(:zip_code)
        }
      ).call
    end

    def build_subscription
      Subscription.new(
        plan: plan,
        customer: customer,
        expires_at: Date.today + Subscription::VALIDITY_DATE,
        active: true
      )
    end

    def parsed_date
      @parsed_date ||= SubscriptionServices::DateParser.new(
        date: payment_params.fetch(:expiration_date)
      )
    end
  end
end
