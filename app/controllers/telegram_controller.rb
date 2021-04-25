# frozen_string_literal: true

class TelegramController < ApplicationController
  skip_forgery_protection

  before_action :request_from_telegram?
  before_action :request_from_myself?

  # @route POST /telegram (telegram)
  def accept_message
    client.send_message(chat_id: message.chat.id, text: "Hello, #{message.from.first_name}")
    render plain: "OK"
  end

  private

  def client
    @client ||= Telegram::Bot::Api.new(Telega::TOKEN)
  end

  def message
    @message ||= Telegram::Bot::Types::Message.new(params[:message].to_unsafe_h)
  end

  def request_from_myself?
    Telega::WHITELISTED_CHATS.any?(message.from.id)
  end

  def request_from_telegram?
    Telega::SUBNETS
      .map {|subnet| IPAddr.new subnet }
      .any? {|subnet| subnet.include?(request.remote_ip) }
  end
end
