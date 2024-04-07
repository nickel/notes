# frozen_string_literal: true

module CommandHandler
  module Errors
    class InvalidInputError < Error
      def self.build(form:)
        super(
          code: :invalid_input,
          message: "Error/s on input data",
          data: CommandHandler::Form.build(form.attributes, form.errors)
        )
      end
    end
  end
end
