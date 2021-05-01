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
      when Telegram::Bot::Types::Message then process_regular_message
      when Telegram::Bot::Types::EditedMessage then "EditedMessage"
      when Telegram::Bot::Types::InlineQuery then "InlineQuery"
      when Telegram::Bot::Types::ChosenInlineResult then "ChosenInlineResult"
      when Telegram::Bot::Types::CallbackQuery then "CallbackQuery"
      end
    end

    private

    attr_reader :context

    def process_regular_message
      if CommandContract.new.call(command: context.message.text).success?
        Command.handle(context)
      else
        flow = Flows.current_flow(context)
        return flow.step_up! if flow

        context.api.send_message(text: "What should I do with it, genius?", **common_keys)
      end
    end

    def common_keys
      {chat_id: context.message.chat.id}
    end
  end

  class CommandContract < Dry::Validation::Contract
    schema do
      required(:command).filled(:string)
    end

    rule(:command) do
      key.failure("is not a command") unless value.match?(%r{^/})
    end
  end

  class Command
    def self.handle(context)
      handler = case context.message.text
                when "/thought" then Flows::AddThought
                when "/start" then Flows::Welcome
                when "/link" then Flows::AddLink
                when "/last_5" then Flows::GetLinks
                else
                  return context.api.send_message(chat_id: context.message.chat.id, text: "Unknown command.")
                end

      handler.new(context).restart!
    end
  end
end
