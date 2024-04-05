# frozen_string_literal: true

module UsersHelper
  def logged_in?
    !!session[:auth]
  end
end
