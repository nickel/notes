# frozen_string_literal: true

require_relative "callable"
require_relative "exception_handling"

module CommandHandler
  class Command
    include Callable
    include ExceptionHandling

    def initialize(**input)
      return unless defined?(self.class::Form)

      @form = self.class::Form.new(**input)
    end

    def call
      if form.nil? || form.valid?
        check_return_value do
          execute
        end
      else
        Response.failure(
          Errors::InvalidInputError.build(form:)
        )
      end
    rescue Exception => e # rubocop:disable Lint/RescueException
      handle_exception(e)
    end

    def execute
      raise NotImplementedError
    end

    private

    attr_reader :form

    def check_return_value(&blk)
      response = blk.call
      return response if response.is_a?(Response)

      message =
        "Return value from #{self.class}#execute must be a Response object, got #{response.class}"
      case environment&.to_sym
      when :development, :test
        raise message
      else
        response
      end
    end

    def environment
      ENV["RAILS_ENV"]
    end
  end
end
