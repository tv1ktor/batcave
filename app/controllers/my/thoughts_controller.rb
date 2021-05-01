# frozen_string_literal: true

module My
  class ThoughtsController < ApplicationController
    def index
      @thoughts = ThoughtDecorator.decorate_collection(Thought.all)
    end
  end
end
