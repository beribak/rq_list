class TranslateContentJob < ApplicationJob
  queue_as :default

  def perform(record, field_name, target_locale)
    # Call the translate method on the record for the specific field
    record.send("translate_#{field_name}!", target_locale)
  end
end
