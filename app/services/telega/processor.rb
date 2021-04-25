# frozen_string_literal: true

module Telega
  class Processor
    def initialize(client, message)
      @client = client
      @message = message
    end

    def call; end

    attr_reader :client, :message
  end
end
