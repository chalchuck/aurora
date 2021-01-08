# frozen_string_literal: true

class PublishOnboardedUser < BaseCommand
  private

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def payload
    @result = {}
  end

  def publish_user!
    publish_params = {
      name: [user.first_name, user.last_name].compact.join(' '),
      email: user.email
    }.with_indifferent_access

    PubSubNotifier.publish!(publish_params)
  end

  class PubSubNotifier
    def self.pubsub
      @pubsub ||= Google::Cloud::PubSub.new
    end

    def self.publish!(publish_params)
      # Retrieve a topic
      #
      topic = pubsub.topic(User::SUBSCRIPTION_TOPIC)

      # Publish a new message!
      topic.publish(publish_params)

      # Retrieve a subscription
      subscription = pubsub.subscription(User::SUBSCRIPTION_CHANNEL)

      # Create a subscriber to listen for available messages
      # By default, this block will be called on 8 concurrent threads.
      # This can be changed with the :threads option
      subscriber = subscription.listen do |received_message|
        # process message
        puts "Data: #{received_message.message.data}, published at #{received_message.message.published_at}"
        received_message.acknowledge!
      end

      # Handle exceptions from listener
      subscriber.on_error do |exception|
        puts "Exception: #{exception.class} #{exception.message}"
      end

      # Gracefully shut down the subscriber on program exit, blocking until
      # all received messages have been processed or 10 seconds have passed
      at_exit do
        subscriber.stop!(10)
      end
    end
  end
end
