# frozen_string_literal: true

namespace :subscriptions do
  desc 'Renew subscriptions'
  task renew: :environment do
    Subscription.inactive.includes(:plan, customer: :payments).find_in_batches do |group|
      group.each { |subscription| SubscriptionServices::Renew.new(subscription: subscription).call }
    end
  end

  desc 'Deactivate expired subscriptions'
  task deactivate_expired: :environment do
    Subscription.expired.update_all(active: false)
  end
end
