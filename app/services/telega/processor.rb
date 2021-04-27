# frozen_string_literal: true

module Telega
  class Processor
    # @param context [Telega::Context]
    def initialize(context)
      @context = context
    end

    # More on types and how each type is triggered:
    # https://core.telegram.org/bots/api#getting-updates
    def call
      case context.message
      when Telegram::Bot::Types::Message
        return Command.new(context).handle if CommandContract.new.call(command: context.message.text).success?

        "Message"
      when Telegram::Bot::Types::EditedMessage
        "EditedMessage"
      when Telegram::Bot::Types::InlineQuery
        "InlineQuery"
      when Telegram::Bot::Types::ChosenInlineResult
        "ChosenInlineResult"
      when Telegram::Bot::Types::CallbackQuery
        "CallbackQuery"
      end
    end

    private

    attr_reader :context
  end

  class CommandContract < Dry::Validation::Contract
    COMMAND_REGEXP = %r{^/}

    schema do
      required(:command).filled(:string)
    end

    rule(:command) do
      key.failure("is not a command") unless value.match?(COMMAND_REGEXP)
    end
  end

  class Command
    def initialize(context)
      @context = context
    end

    def handle
      case @context.message.text
      when "/thought"
        context.api.send_message(
          char_id: context.message.chat.id,
          text: "Hey. I should do flow structure with new User <-> Flow(with steps) relation"
        )
      end
    end

    private

    attr_reader :context
  end
end
