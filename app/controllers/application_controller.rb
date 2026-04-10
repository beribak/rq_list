class ApplicationController < ActionController::Base
  # before_action :authenticate_user!
  before_action :set_locale
  before_action :set_theme

  helper_method :current_theme, :dark_theme?

  private

  def set_locale
    I18n.locale = params[:locale] || session[:locale] || I18n.default_locale
    session[:locale] = I18n.locale
  end

  def set_theme
    selected_theme = params[:theme].presence_in(%w[dark light]) || session[:theme].presence_in(%w[dark light]) || cookies[:theme].presence_in(%w[dark light]) || "dark"
    session[:theme] = selected_theme
    cookies[:theme] = {
      value: selected_theme,
      expires: 1.year.from_now,
      same_site: :lax
    }
    @current_theme = selected_theme
  end

  def current_theme
    @current_theme || "dark"
  end

  def dark_theme?
    current_theme == "dark"
  end

  def default_url_options
    { locale: I18n.locale }
  end
end
