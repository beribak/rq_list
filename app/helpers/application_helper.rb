module ApplicationHelper
  def next_theme
    dark_theme? ? "light" : "dark"
  end

  def theme_toggle_label
    dark_theme? ? t("theme.switch_to_light") : t("theme.switch_to_dark")
  end

  def theme_toggle_icon
    dark_theme? ? "bi-sun" : "bi-moon-stars"
  end
end
