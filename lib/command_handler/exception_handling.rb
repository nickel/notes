# frozen_string_literal: true

module CommandHandler
  module ExceptionHandling
    extend ActiveSupport::Concern

    class_methods do
      def rescue_from(exception, **options, &blk)
        @exceptions ||= {}
        @exceptions[exception] = blk.nil? ? options : { run: blk }
      end
    end

    def handle_exception(exception)
      handler = self.class.instance_variable_get(:@exceptions)&.fetch(exception.class, nil)
      case handler&.keys&.first&.to_sym
      when nil
        raise exception
      when :raise
        raise handler[:raise].new(exception)
      when :run
        run_exception_handler(handler[:run], exception)
      else
        raise ArgumentError.new("Unsupported option. Must be :raise or :run")
      end
    end

    private

    def run_exception_handler(handler, exception)
      case handler
      when Proc
        call_proc(exception, handler)
      when Symbol
        call_method(exception, handler)
      else
        raise ArgumentError.new("Unsupported exception handler. Must be method, Proc or block")
      end
    end

    def call_method(exception, executor)
      case method(executor).arity
      when 0
        send(executor)
      when 1
        send(executor, exception)
      else
        raise_argument_count
      end
    end

    def call_proc(exception, executor)
      case executor.arity
      when 0
        executor.call
      when 1
        executor.call(exception)
      else
        raise_argument_count
      end
    end

    def raise_argument_count
      raise ArgumentError.new("Exception handler must accept 0 or 1 arguments")
    end
  end
end
