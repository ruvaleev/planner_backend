# frozen_string_literal: true

class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
