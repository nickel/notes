# frozen_string_literal: true

module Errors
  class Error < StandardError
    attr_reader :code, :message, :data

    def self.build(code:, message: nil, data: nil)
      new(code:, message: (message || code).to_s, data:)
    end

    private

    private_class_method :new

    def initialize(code:, message:, data:)
      @code = code
      @message = message
      @data = data
      @source = caller_locations(4, 1)[0]

      super
    end
  end
end
