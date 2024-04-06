# frozen_string_literal: true

module CommandHandler
  module Configurable
    class MissingConfiguration < RuntimeError; end

    class << self
      def configuration
        required_configuration + optional_configuration
      end

      def required_configuration
        %i()
      end

      def optional_configuration
        %i()
      end

      def default_configuration
        {}
      end
    end

    def configure
      Configurable.default_configuration.each do |key, value|
        instance_variable_set(:"@#{key}", value) if instance_variable_get(:"@#{key}").nil?
      end

      yield self

      setup
    end

    def setup
      Configurable.required_configuration.each do |key|
        raise MissingConfiguration.new("#{key} is missing") if instance_variable_get(:"@#{key}").nil?
      end

      self
    end

    def reset!
      Configurable.configuration.each do |key|
        instance_variable_set(:"@#{key}", nil)
      end
    end
  end
end
