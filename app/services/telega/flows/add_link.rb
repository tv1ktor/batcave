# frozen_string_literal: true

module Telega
  module Flows
    class AddLink < Base
      private

      flow_name "add_link"

      def step_0
        api.send_message(chat_id: message.chat.id, text: "Waiting for the link")
      end

      def step_1
        link = message.text
        # Handle it differently. Silent fail is bad
        return unless link.match? URI::DEFAULT_PARSER.make_regexp

        Link.create!(url: link)

        api.delete_message(chat_id: message.chat.id, message_id: message.message_id)
        api.send_message(chat_id: message.chat.id, text: "I saved it")
      end

      # def step_2
      #   # This step should be initiated by backend and in the future should parse link and retrieve content.
      #   # E.x. Telegram's quick view.
      # end
    end
  end
end
