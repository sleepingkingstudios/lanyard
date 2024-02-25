# frozen_string_literal: true

class DataSetRoleLastEventAt < ActiveRecord::Migration[7.0]
  def down
    Lanyard::Migrations::SetRoleLastEventAt.down
  end

  def up
    Lanyard::Migrations::SetRoleLastEventAt.up
  end
end
