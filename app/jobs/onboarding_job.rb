# frozen_string_literal: true

class OnboardingJob < BaseJob
  queue_as :low_priority

  discard_on ActiveRecord::RecordNotFound
  retry_on ActiveRecord::RecordNotFound, wait: 5.seconds, attempts: 2

  def perform(user_id)
    user = User.find(user_id)
    published_result = PublishOnboardedUser.call(user)

    if published_result.success?
    #  Do something creative here
    else
      #  Report this to the authorities.
    end
  end
end
