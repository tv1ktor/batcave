# frozen_string_literal: true

namespace :telegram do # rubocop:disable Metrics/BlockLength [35/25]
  desc "Make a call to Telegram's setWebhook"

  task set_webhook: :environment do
    tg = Telegram::Bot::Api.new(Telega::TOKEN)

    handler_url = ENV.fetch("TMP_SET_WEBHOOK_URI", "")

    # Use an empty string to remove webhook integration
    if handler_url.blank?
      puts "Sending request to remove webhook url from Telegram"
    else
      handler_url += "/telegram"
      puts "Sending request to setup webhook url[#{handler_url}]."
    end

    tg.call("setWebhook", url: handler_url)

    puts "Successfully set up webhook."
  rescue Telegram::Bot::Exceptions::ResponseError
    puts "Failed to set up webhook. Telegram responded with status: #{response.code}."
  end

  desc "Contact ngrok for https tunnel and set webhook at Telegram"

  task set_webhook_with_ngrok: :environment do
    ngrok_url = "http://localhost:4040/api/%<method>s"

    puts "Contacting ngrok API."

    response = Net::HTTP.get(URI.parse(ngrok_url % {method: "tunnels"}))
    response_json = JSON.parse response

    if response_json["status_code"] && response_json["status_code"] != "200"
      puts "Ngrok server experiences problems."
      exit 1
    end

    puts "Retrieving HTTPS tunnel address."

    tunnel = response_json["tunnels"].find {|t| t["public_url"].match?(/^https/) }

    if tunnel
      puts "Preparing to send request to Telegram."

      ENV["TMP_SET_WEBHOOK_URI"] = tunnel["public_url"]
      Rake::Task["telegram:set_webhook"].invoke
    else
      puts "Tunnel was not found."
    end
  end
end
