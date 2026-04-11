class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale

  helper_method :current_theme

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def current_theme
    "light"
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
