# frozen_string_literal: true

module Lanyard::Actions::Applications::Middleware
  # Assigns the job search ID of the current job search, if any.
  class AssignCurrentJobSearch < Cuprum::Command
    include Cuprum::Middleware

    private

    attr_reader \
      :repository,
      :request

    def build_request
      params = { 'job_search_id' => current_job_search_id }

      request
        .class
        .new(
          context: request.context,
          **request.properties.merge(
            params:       request.params.merge(params),
            query_params: request.query_params.merge(params)
          )
        )
    end

    def current_job_search_id
      order    = { start_date: :desc }
      matching = step do
        job_searches_collection
          .find_matching
          .call(limit: 1, order: order)
      end

      matching.first&.id
    end

    def job_searches_collection
      repository.find_or_create(entity_class: JobSearch)
    end

    def process(next_command, request:, repository:, **rest)
      @repository = repository
      @request    = request

      super(
        next_command,
        request:    build_request,
        repository: repository,
        **rest
      )
    end
  end
end
