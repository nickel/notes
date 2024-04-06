# frozen_string_literal: true

module CommandHandler
  class Error
    attr_reader :code, :message, :data, :errors, :retryable

    def self.build(code:, message: nil, data: nil, errors: {}, retryable: nil)
      new(
        code:,
        message: (message || code).to_s,
        data:,
        errors:,
        retryable:
      )
    end

    def retryable?
      raise NotImplementedError if @retryable.nil?

      @retryable
    end

    def to_h
      { code:, message:, data:, retryable:, errors: }
    end

    def ==(other)
      to_h == other.to_h
    end

    def as_response
      Response.failure(self)
    end

    private

    private_class_method :new

    def initialize(code:, message:, data:, errors: {}, retryable: nil)
      @code = code
      @message = message
      @data = data
      @errors = errors
      @retryable = retryable
    end
  end
end
