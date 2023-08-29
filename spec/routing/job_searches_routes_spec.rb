# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "#{JobSearchesController} routes", type: :routing do
  include Librum::Core::RSpec::Contracts::RoutingContracts

  include_contract 'should route to view resource',
    'job-searches',
    controller: 'job_searches'
end
