# frozen_string_literal: true

module ApplicationHelper
  def logged_in?
    !!session[:auth]
  end
end
