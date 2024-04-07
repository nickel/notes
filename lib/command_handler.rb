# frozen_string_literal: true

require "active_support/concern"
require "active_support/notifications"

require_relative "command_handler/callable"
require_relative "command_handler/configurable"
require_relative "command_handler/response"
require_relative "command_handler/error"
require_relative "command_handler/form"
require_relative "command_handler/errors"
require_relative "command_handler/command"

module CommandHandler
  extend ActiveSupport::Concern
  class NoResponseObjectException < StandardError; end

  class << self
    include Configurable
  end
end
