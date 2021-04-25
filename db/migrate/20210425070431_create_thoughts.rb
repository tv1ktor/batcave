# frozen_string_literal: true

class CreateThoughts < ActiveRecord::Migration[6.1]
  def change
    create_table :thoughts do |t|
      t.string :body, null: false

      t.timestamps
    end
  end
end
