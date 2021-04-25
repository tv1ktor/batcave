# frozen_string_literal: true

# Telegram service will:
#
# 1. Accept only my messages to it.
# 2. Read messages and post them to my `thoughts` pages.
# 3. This will happen in real time `Websockets + Telegram callbacks API`
module Telega
  SUBNETS = %w[91.108.4.0/22 149.154.160.0/20].freeze
  TOKEN = Rails.application.credentials.telegram[:api_token].freeze
  WHITELISTED_CHATS = Rails.application.credentials.telegram[:my_ids].freeze
end
