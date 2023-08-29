# frozen_string_literal: true

module Lanyard::View::Components::JobSearches
  # Renders a form for a JobSearch record.
  class Form < Librum::Core::View::Components::Resources::Form
    private

    def default_data
      { 'job_search' => JobSearch.new }
    end
  end
end
