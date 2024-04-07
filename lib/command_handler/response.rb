# frozen_string_literal: true

module CommandHandler
  class Response
    class ValueError < StandardError; end

    attr_reader :value, :meta, :success

    def self.success(value)
      new(success: true, value:)
    end

    def self.failure(value)
      new(success: false, value:)
    end

    def self.sequence(responses)
      if responses.all?(&:success?)
        Response.success responses.map(&:value)
      else
        responses.find(&:failure?)
      end
    end

    def initialize(success:, value: nil, meta: {})
      @success = success
      @value = value
      @meta = meta || {}
    end

    def with_meta(value)
      @meta = value
      self
    end

    def success?
      @success == true
    end

    def ==(other)
      value == other.value && success == other.success
    end

    def failure?
      !success?
    end

    def success_tap
      yield(value) if success?

      self
    end

    def value!
      raise ValueError.new(value) if failure?

      value
    end

    def and_then
      return self if failure?

      yield(value)
    end

    def ensure
      yield(self)
    end

    def on_success
      yield(value) if success?

      self
    end

    def on_failure
      return self if success?

      yield(value)
      self
    end

    # Calls given block if it's a failure, otherwise returns itself.
    def or_else
      return self if success?

      yield(value)
    end
  end
end
