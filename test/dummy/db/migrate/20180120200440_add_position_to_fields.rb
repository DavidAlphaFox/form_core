# frozen_string_literal: true

class AddPositionToFields < ActiveRecord::Migration[5.1]
  def change
    change_table :fields do |t|
      t.integer :position
    end
  end
end
