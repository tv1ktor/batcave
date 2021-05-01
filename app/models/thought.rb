# frozen_string_literal: true

class Thought < ApplicationRecord
  validates :body, length: {maximum: 280}, allow_blank: false

  after_save :broadcast

  private

  def broadcast
    template = My::ThoughtsController.render(
      "my/thoughts/_thought", layout: false, locals: {thought: decorate}
    )
    ActionCable.server.broadcast("thoughts", template)
  end
end
