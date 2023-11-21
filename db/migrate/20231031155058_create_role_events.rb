# frozen_string_literal: true

class CreateRoleEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :role_events, id: :uuid do |t|
      t.string  :type,        null: false, default: ''
      t.string  :slug,        null: false, default: ''
      t.date    :event_date,  null: false
      t.integer :event_index, null: false
      t.jsonb   :data,        null: false, default: {}
      t.text    :notes,       null: false, default: ''

      t.timestamps
    end

    add_reference :role_events, :role, index: false, type: :uuid

    add_index :role_events, %i[role_id event_index], unique: true

    add_index :role_events, %i[role_id slug], unique: true
  end
end
