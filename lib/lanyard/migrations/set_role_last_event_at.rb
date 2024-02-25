# frozen_string_literal: true

module Lanyard::Migrations
  # Data migration for assigning the last_event_at value for all Roles.
  class SetRoleLastEventAt
    def self.down
      Role.find_in_batches do |batch|
        batch.each do |role|
          # rubocop:disable Rails/SkipsModelValidations
          role.update_column(:last_event_at, nil)
          # rubocop:enable Rails/SkipsModelValidations
        end
      end
    end

    def self.up
      Role.find_in_batches do |batch|
        batch.each do |role|
          next if role.last_event_at.present?

          event         = role.events.order(event_date: :desc).first
          last_event_at = event&.event_date&.beginning_of_day || role.created_at

          # rubocop:disable Rails/SkipsModelValidations
          role.update_column(:last_event_at, last_event_at)
          # rubocop:enable Rails/SkipsModelValidations
        end
      end
    end
  end
end
