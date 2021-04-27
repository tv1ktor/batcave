# frozen_string_literal: true

class TelegramController < ApplicationController
  skip_forgery_protection

  before_action :request_from_telegram?
  before_action :request_from_myself?

  class Forbidden < StandardError; end

  rescue_from Forbidden, with: :ok

  # @route POST /telegram (telegram)
  def accept_message
    context = Telega::Context.new(api: api, message: message)
    Telega::Processor.new(context).call
    ok
  end

  private

  def api
    @api ||= Telegram::Bot::Api.new(Telega::TOKEN)
  end

  def message
    @message ||= Telegram::Bot::Types::Message.new(params[:message].to_unsafe_h)
  end

  def request_from_myself?
    Telega::WHITELISTED_CHATS.any?(message.from.id) || raise(Forbidden)
  end

  def request_from_telegram?
    Telega::SUBNETS
      .map {|subnet| IPAddr.new subnet }
      .any? {|subnet| subnet.include?(request.remote_ip) } || raise(Forbidden)
  end

  def ok
    # Might wanna track who else is knocking on my doors
    render plain: "OK", status: :ok
  end
end
