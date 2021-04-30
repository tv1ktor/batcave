# frozen_string_literal: true

module Telega
  module Flows
    class Base
      class << self
        def flow_name(name=nil)
          @flow_name ||= name
        end
      end

      def initialize(context)
        @context = context
        @store = Redis.current
        @step_number = store.get(flow_key).to_i
      end

      def restart!
        @step_number = 0
        store.set(flow_key, @step_number)
        step_up!
      end

      def step_up!
        send("step_#{step_number}".to_sym)
        @step_number = store.incr(flow_key)
        # Since we start from 0 we need '>='
        store.del(flow_key) if @step_number >= step_count
      end

      private

      attr_reader :store, :context, :step_number

      def step_count
        @step_count ||= (methods + private_methods).count {|m| m.match?(/^step_\d{1,2}/) }
      end

      def flow_key
        @flow_key ||= REDIS_PREFIX + self.class.flow_name
      end

      def message
        @message ||= context.message
      end

      def api
        @api ||= context.api
      end
    end
  end
end
