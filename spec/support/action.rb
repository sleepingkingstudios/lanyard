# frozen_string_literal: true

module Spec::Support
  class Action < Cuprum::Command
    def initialize(action, repository: nil)
      super()

      @action     = action
      @repository = repository
    end

    attr_reader \
      :action,
      :repository

    private

    def create_entity(attributes:)
      attributes
    end

    def process(attributes:)
      if action == :create
        create_entity(attributes: attributes)
      else
        update_entity(attributes: attributes)
      end
    end

    def update_entity(attributes:)
      attributes
    end
  end
end
