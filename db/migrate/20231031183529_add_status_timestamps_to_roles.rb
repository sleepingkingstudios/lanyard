# frozen_string_literal: true

class AddStatusTimestampsToRoles < ActiveRecord::Migration[7.0]
  def change
    change_table :roles, bulk: true do |t|
      t.rename   :opened_at, :applied_at
      t.datetime :interviewing_at
      t.datetime :offered_at
    end
  end
end
