# frozen_string_literal: true

module Spec::Support
  class Action < Cuprum::Command
    def initialize(action, repository: nil, resource: nil)
      super()

      @action     = action
      @repository = repository
      @resource   = resource
    end

    attr_reader \
      :action,
      :repository,
      :resource

    private

    def collection
      repository.find_or_create(
        entity_class:   resource.entity_class,
        qualified_name: resource.qualified_name
      )
    end

    def create_entity(attributes:)
      attributes
    end

    def destroy_entity(primary_key:)
      # :nocov:
      collection.find_one.call(primary_key: primary_key)
      # :nocov:
    end

    def find_entity(primary_key:)
      # :nocov:
      collection.find_one.call(primary_key: primary_key)
      # :nocov:
    end

    def process(attributes: {}, primary_key: nil)
      case action
      when :create
        create_entity(attributes: attributes)
      when :destroy
        destroy_entity(primary_key: primary_key)
      when :show
        find_entity(primary_key: primary_key)
      when :update
        update_entity(attributes: attributes)
      end
    end

    def update_entity(attributes:)
      attributes
    end
  end
end
