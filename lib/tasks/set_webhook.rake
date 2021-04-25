# frozen_string_literal: true

namespace :telegram do
  desc "Make a call to Telegram's setWebhook"

  # Usage: telegram:set_webhook URI=<new-uri-here>
  task set_webhook: :environment do
    tg = Telegram::Bot::Api.new(Telega::TOKEN)

    handler_url = ENV.fetch("URI", "")

    # Use an empty string to remove webhook integration
    if handler_url.blank?
      puts "Sending request to remove webhook url from Telegram"
    else
      handler_url += "/telegram"
      puts "Sending request to setup webhook url[#{handler_url}] to Telegram."
    end

    tg.call("setWebhook", url: handler_url)

    puts "Success"
  rescue Telegram::Bot::Exceptions::ResponseError
    puts "Failed with status: #{response.code}"
  end
end
