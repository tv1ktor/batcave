# frozen_string_literal: true

module Telega
  # This is class that holds all necessary objects to process and respond to telegram webhook
  class Context < Dry::Struct
    attribute :api, Dry::Types().Instance(Telegram::Bot::Api)
    attribute :message, Dry::Types().Instance(Telegram::Bot::Types::Message)
  end
end
