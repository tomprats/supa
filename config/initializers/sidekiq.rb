redis_url = Rails.application.secrets.redis_url

Rails.application.config.active_job.queue_adapter = :sidekiq
Rails.application.config.cache_store = :redis_cache_store, {
  url: "#{redis_url}/cache",
}

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }
end

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }
end
