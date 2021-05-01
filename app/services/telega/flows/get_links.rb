# frozen_string_literal: true

module Telega
  module Flows
    class GetLinks < Base
      private

      flow_name "get_link"

      def step_0
        links = Link.last(5).pluck(:url)

        response = ""
        # TODO: [link-parser]: display header and short overview?
        # TODO Use telegram's ability to read md/html syntax for better view.
        links.each.with_index(1) {|link, index| response += "#{index} - #{link}\n" }

        if response.empty?
          api.send_message(chat_id: message.chat.id, text: "You haven't saved anything yet.")
        else
          api.send_message(chat_id: message.chat.id, text: response)
        end
      end
    end
  end
end
