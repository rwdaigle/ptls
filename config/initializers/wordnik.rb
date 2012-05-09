Wordnik.configure do |config|
  config.api_key = ENV['WORDNIK_API_KEY']
  config.response_format = 'json'
  config.logger = Rails.logger
end