# frozen_string_literal: true

require 'redis'

redis_uri = ENV['REDIS_URL'] || 'redis://localhost:6379'
uri = URI.parse(redis_uri)
$redis = Redis.new(host: uri.host, port: uri.port, password: uri.password)
