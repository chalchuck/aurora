# frozen_string_literal: true

class OnboardUser < BaseCommand
  private

  attr_reader :params

  def initialize(params)
    @params = params
  end

  def payload
    @user = User.new(params)

    if @user.save
      @result = @user
      OnboardingJob.perform_now(@user.id)
    else
      @errors = @user.errors
    end
  end
end
