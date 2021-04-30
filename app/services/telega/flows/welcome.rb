# frozen_string_literal: true

module Telega
  module Flows
    class Welcome < Base
      private

      flow_name "welcome"

      def step_0
        api.send_message(chat_id: message.chat.id, text: "Good to see you. I'm S.H.E.")
      end
    end
  end
end
