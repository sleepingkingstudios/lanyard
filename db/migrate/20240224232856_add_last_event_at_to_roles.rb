# frozen_string_literal: true

class AddLastEventAtToRoles < ActiveRecord::Migration[7.0]
  def change
    change_table :roles, bulk: true do |t|
      t.datetime :last_event_at
    end
  end
end
