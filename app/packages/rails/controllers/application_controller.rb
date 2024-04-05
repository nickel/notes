# frozen_string_literal: true

class ApplicationController < ActionController::Base
  append_view_path(Dir.glob(Rails.root.join("app/packages/*/views")))
end
