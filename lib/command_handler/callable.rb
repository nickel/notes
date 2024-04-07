# frozen_string_literal: true

module CommandHandler
  module Callable
    extend ActiveSupport::Concern

    class_methods do
      def call(*args, **opts)
        new(*args, **opts).call
      end
    end
  end
end
