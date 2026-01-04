module Translatable
  extend ActiveSupport::Concern

  included do
    has_many :translations, as: :translatable, dependent: :destroy
  end

  class_methods do
    def translates(*attributes)
      attributes.each do |attribute|
        # Define the translated method (e.g., name_translated)
        define_method "#{attribute}_translated" do
          current_locale = I18n.locale.to_s
          source_locale = content_locale || I18n.default_locale.to_s

          # If we're viewing in the same language as the content was created, return original
          return send(attribute) if current_locale == source_locale

          # Try to find a translation for the current locale
          translation = translations.find_by(field_name: attribute.to_s, locale: current_locale)

          # Return translation if it exists, otherwise fall back to original
          translation&.content || send(attribute)
        end

        # Define the translate method (e.g., translate_name!)
        define_method "translate_#{attribute}!" do |target_locale|
          return if send(attribute).blank?

          source_locale = content_locale || I18n.default_locale.to_s
          target_locale = target_locale.to_s

          # Don't translate if target is the same as source
          return if source_locale == target_locale

          begin
            # Initialize Google Cloud Translate client with API key
            translate_client = Google::Cloud::Translate::V2.new(
              key: ENV.fetch("GOOGLE_CLOUD_API_KEY", nil)
            )

            # Translate using Google Cloud Translation API
            # Google supports 'mk' for Macedonian, 'en' for English
            result = translate_client.translate(
              send(attribute),
              from: source_locale,
              to: target_locale
            )

            # Save or update the translation
            translation = translations.find_or_initialize_by(
              field_name: attribute.to_s,
              locale: target_locale
            )
            translation.content = result.text
            translation.save!
          rescue Google::Cloud::Error => e
            Rails.logger.error "Google Translate API failed: #{e.message}"
            # Don't create/update translation on error
          rescue StandardError => e
            Rails.logger.error "Translation error: #{e.message}"
          end
        end
      end
    end
  end

  # Helper method to get the opposite locale
  def opposite_locale
    (content_locale || I18n.default_locale.to_s) == "en" ? "mk" : "en"
  end
end
