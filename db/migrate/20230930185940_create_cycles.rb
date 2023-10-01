# frozen_string_literal: true

class CreateCycles < ActiveRecord::Migration[7.0]
  def change
    create_table :cycles, id: :uuid do |t|
      t.string :name,          null: false, default: ''
      t.string :slug,          null: false, default: ''
      t.string :year,          null: false, default: ''
      t.integer :season_index, null: false

      t.timestamps
    end

    add_index :cycles, :name,                 unique: true
    add_index :cycles, :slug,                 unique: true
    add_index :cycles, %i[year season_index], unique: true
  end
end
