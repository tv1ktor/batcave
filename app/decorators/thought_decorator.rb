# frozen_string_literal: true

class ThoughtDecorator < ApplicationDecorator
  def view_id
    "thought_#{id}"
  end

  def view_date
    if created_at.year > Time.current.year
      created_at.strftime "%B, %Y"
    else
      created_at.strftime "%A, %B %e"
    end
  end
end
