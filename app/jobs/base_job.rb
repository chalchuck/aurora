# frozen_string_literal: true

class BaseJob < ApplicationJob
  ActiveSupport::Notifications.subscribe 'enqueue_retry.active_job' do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    payload = event.payload
    job = payload[:job]
    error = payload[:error]
    message = "#{job.class} (JID #{job.job_id})
       with arguments #{job.arguments.join(', ')}
       will be retried again in #{payload[:wait]} minutes
       due to error '#{error.class} - #{error.message}'.
       It is executed #{job.executions} times so far.".squish

    Rails.logger(message)
  end

  ActiveSupport::Notifications.subscribe 'retry_stopped.active_job' do |*args|
    event = ActiveSupport::Notifications::Event.new *args
    payload = event.payload
    job = payload[:job]
    error = payload[:error]
    message = "Stopped processing #{job.class} (JID #{job.job_id})
      further with arguments #{job.arguments.join(', ')}
      since it failed due to '#{error.class} - #{error.message}' error
      which reoccurred #{job.executions} times.".squish

    Rails.logger(message)
    # The only way I know of adding this job to a morgue queue, is to use Sidekiq,
    # and it is not a dependancy in this assignemnt.
  end
end
