# frozen_string_literal: true

class ThoughtChannel < ApplicationCable::Channel
  def subscribed
    stream_from "thoughts"
  end
end
