# frozen_string_literal: true

module CommandHandler
  module Form
    module HashInitialisation
      extend ActiveSupport::Concern

      include ActiveModel::AttributeAssignment

      def initialize(new_attributes = {})
        assign_attributes(new_attributes) if new_attributes

        super()
      end
    end

    extend ActiveSupport::Concern

    include HashInitialisation

    include ActiveModel::Attributes
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    def self.build(attributes = {}, errors = []) # rubocop:disable Metrics/MethodLength
      klass = Class.new do
        include CommandHandler::Form

        attributes.each_key { |key| attr_accessor key }

        def self.model_name
          ActiveModel::Name.new(self, nil, "form")
        end

        def method_missing(*_args)
          ""
        end

        def respond_to_missing?(method_name, include_private = false)
          super
        end
      end

      klass.new(attributes).tap do |form|
        errors.each do |attribute_with_error|
          form.errors.add(
            attribute_with_error.attribute,
            attribute_with_error.type,
            message: attribute_with_error.message
          )
        end
      end
    end
  end
end
