# frozen_string_literal: true

Google::Cloud.configure do |config|
  config.project_id = Rails.application.credentials.PROJECT_ID,
                      config.credentials = Rails.application.credentials.PROJECT_CREDENTIALS
end
