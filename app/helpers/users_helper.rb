module UsersHelper
  def logged_in?
    !!session[:auth]
  end
end
