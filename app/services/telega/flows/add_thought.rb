# frozen_string_literal: true

module Telega
  module Flows
    class AddThought < Base
      private

      flow_name "add_thought"

      def step_0
        api.send_message(chat_id: message.chat.id, text: "Ok, ready to hear it.")
      end

      def step_1
        Thought.create!(body: message.text)
        api.send_message(chat_id: message.chat.id, text: "Published")
      end
    end
  end
end
