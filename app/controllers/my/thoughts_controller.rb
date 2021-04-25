# frozen_string_literal: true

module My
  class ThoughtsController < ApplicationController
    def index
      @thoughts = Thought.all
    end
  end
end
