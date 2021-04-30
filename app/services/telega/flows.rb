# frozen_string_literal: true

module Telega
  module Flows
    REDIS_PREFIX = "user:flow-"

    # There should be always only one flow for user hanging in Redis
    def self.current_flow(context)
      name = Redis.current.keys(flow_matcher).first&.sub(REDIS_PREFIX, "")
      return unless name

      "Telega::Flows::#{name.camelize}".safe_constantize&.new(context)
    end

    def self.reset_all!
      redis = Redis.current
      redis.del(*redis.keys(flow_matcher))
    end

    def self.flow_matcher
      "#{REDIS_PREFIX}*"
    end
  end
end
