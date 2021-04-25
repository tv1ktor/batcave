# frozen_string_literal: true

class Thought < ApplicationRecord
  validates :body, length: {maximum: 280}, allow_blank: false
end
