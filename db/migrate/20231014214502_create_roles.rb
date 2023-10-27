# frozen_string_literal: true

class CreateRoles < ActiveRecord::Migration[7.0]
  def change # rubocop:disable Metrics/AbcSize
    create_table :roles, id: :uuid do |t|
      t.string   :slug,              null: false, default: ''
      t.string   :status,            null: false, default: 'new'
      t.string   :agency_name,       null: false, default: ''
      t.string   :client_name,       null: false, default: ''
      t.string   :company_name,      null: false, default: ''
      t.string   :compensation_type, null: false, default: 'unknown'
      t.string   :contract_type,     null: false, default: 'unknown'
      t.string   :job_title,         null: false, default: ''
      t.string   :location_type,     null: false, default: 'unknown'
      t.string   :source,            null: false, default: 'unknown'
      t.string   :recruiter_name,    null: false, default: ''
      t.jsonb    :data,              null: false, default: {}
      t.text     :notes,             null: false, default: ''

      t.timestamps
      t.datetime :opened_at
      t.datetime :closed_at
    end

    add_reference :roles, :cycle, index: false, type: :uuid

    add_index :roles, :slug, unique: true

    add_index :roles, %i[cycle_id slug], unique: true
  end
end
