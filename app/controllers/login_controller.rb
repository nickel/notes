class LoginController < ApplicationController
  before_action :authenticate_user!

  def create
    session[:auth] = true

    redirect_to root_path
  end

  private

  def authenticate_user!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["AUTH_USER_NAME"] && password == ENV["AUTH_USER_PASS"]
    end
  end
end
