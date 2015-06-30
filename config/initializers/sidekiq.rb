Sidekiq.configure_server do |config|
  config.redis = { url: Rails.configuration.redis[:url] }
  config.error_handlers << Proc.new { |ex, context| Sidekiq::ApiDown.notify(ex, context) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.configuration.redis[:url] }
end
