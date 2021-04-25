# frozen_string_literal: true

# Telegram service will:
#
# 1. Subscribe me.
# 2. Accept only my messages to it.
# 3. Read messages and post them to my `thoughts` pages.
# 4. This will happen in real time `Websockets + Telegram callbacks API`
module Telega
  SUBNETS = %w[91.108.4.0/22 149.154.160.0/20].freeze
  TOKEN = Rails.application.credentials.telegram[:api_token].freeze
  WHITELISTED_CHATS = [335_054_859, 588_686_230].freeze
end
