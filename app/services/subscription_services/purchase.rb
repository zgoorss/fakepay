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

        payment
        subscription = build_subscription
        subscription.payments << payment
        subscription.save!
      end
    end

    private

    attr_reader :customer_id, :plan_id, :customer_params, :payment_params

    def subscription_exists?
      Subscription.exists?(customer: customer, plan: plan)
    end

    def plan
      @plan ||= Plan.find_by!(id: plan_id)
    end

    def customer
      @customer ||= CustomerServices::FindOrCreateFromParams.new(customer_params).call
    end

    def payment
      @payment ||= PaymentServices::CreatePayment.new(
        amount: plan.price, payment_params: payment_params
      ).call
    end

    def build_subscription
      Subscription.new(
        plan: plan,
        customer: customer,
        expires_at: Time.zone.now + 1.month,
        active: true
      )
    end
  end
end
