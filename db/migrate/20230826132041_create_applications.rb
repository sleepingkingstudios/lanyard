# frozen_string_literal: true

class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    create_table :applications, id: :uuid do |t|
      t.string :slug,   null: false, default: ''
      t.jsonb  :data,   null: false, default: {}
      t.text   :notes,  null: false, default: ''
      t.string :status, null: false, default: 'new'

      t.string :client_name,       null: false, default: ''
      t.string :company_name,      null: false, default: ''
      t.string :compensation_type, null: false, default: 'unknown'
      t.string :contract_type,     null: false, default: 'unknown'
      t.string :job_title,         null: false, default: ''
      t.string :location_type,     null: false, default: 'unknown'
      t.string :source,            null: false, default: ''

      t.timestamps
      t.datetime :closed_at
      t.datetime :opened_at
    end

    add_index :applications, :slug, unique: true
  end
end
