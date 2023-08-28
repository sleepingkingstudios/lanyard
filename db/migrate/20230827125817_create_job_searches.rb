# frozen_string_literal: true

class CreateJobSearches < ActiveRecord::Migration[7.0]
  def change
    create_table :job_searches, id: :uuid do |t|
      t.string :slug,       null: false, default: ''
      t.date   :start_date, null: false
      t.date   :end_date

      t.timestamps
    end

    add_index :job_searches, :slug,       unique: true

    add_index :job_searches, :start_date, unique: true

    add_reference :applications,
      :job_search,
      index: false,
      type:  :uuid

    add_index :applications, %i[job_search_id slug], unique: true
  end
end
