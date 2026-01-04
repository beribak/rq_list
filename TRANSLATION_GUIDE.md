# Google Cloud Translation Implementation Guide

## Overview
This application supports **bidirectional automatic translation** between Macedonian and English for all user-generated content (menus, sections, and menu items) using the **Google Cloud Translation API**.

**You can now type in either language and the system will automatically translate to the other!**

## How It Works

### 1. Automatic Bidirectional Translation
When you create or update any menu, section, or menu item:
- The content is saved in whichever language you're currently using (tracked via `content_locale`)
- A background job is triggered to translate to the **opposite** language
- If you type in English → translates to Macedonian
- If you type in Macedonian → translates to English
- Translations are stored in a separate `translations` table

### 2. Viewing Translated Content
- The language toggle in the navbar allows switching between English and Macedonian
- The public menu view (QR code view) automatically displays content in the selected language
- Content shows in the original language when viewing in the language it was created
- Content shows the translation when viewing in the opposite language
- If a translation doesn't exist, the original content is displayed as a fallback

## Translated Fields

### Menus
- Name
- Description

### Sections
- Name

### Menu Items
- Name
- Description

## Technical Implementation

### Database Structure
A polymorphic `translations` table stores all translations:
- `translatable_type` and `translatable_id`: References the original record
- `field_name`: The attribute being translated (e.g., "name", "description")
- `locale`: The target language (e.g., "mk" for Macedonian, "en" for English)
- `content`: The translated text

Each translatable model also has a `content_locale` field that tracks which language the original content was created in.

### Models
All translatable models include the `Translatable` concern:
```ruby
class Menu < ApplicationRecord
  include Translatable
  translates :name, :description
end
```

### Controllers
Controllers automatically track the input language and trigger translations to the opposite language:
```ruby
def create
  @menu = current_user.menus.new(menu_params)
  @menu.content_locale = I18n.locale.to_s  # Track input language
  
  if @menu.save
    # Translate to opposite language (EN→MK or MK→EN)
    trigger_translations(@menu, [:name, :description])
    # ...
  end
end
```

### Views
Views use the `_translated` suffix to display translated content:
```erb
<h1><%= @menu.name_translated %></h1>
<p><%= @menu.description_translated %></p>
```

## Configuration

### Google Cloud API Key
The Google Cloud API key is stored in the `.env` file:
```
GOOGLE_CLOUD_API_KEY=your_google_cloud_api_key_here
```

#### Getting Your API Key:
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the [Cloud Translation API](https://console.cloud.google.com/apis/library/translate.googleapis.com)
4. Go to [API Credentials](https://console.cloud.google.com/apis/credentials)
5. Click "Create Credentials" → "API Key"
6. Copy the API key and add it to your `.env` file
7. (Optional) Restrict the API key to only Cloud Translation API for security

**Free Tier:** Google Cloud Translation offers 500,000 characters per month for free.

### Background Jobs
ActiveJob is configured to use the `:async` adapter for development. For production, consider using:
- Solid Queue (already included in your Gemfile)
- Sidekiq
- Delayed Job

## Usage Examples

### Example 1: Creating Content in English
When you create a menu while in English mode:
- Name: "Summer Menu"
- Description: "Fresh seasonal dishes"

The system:
1. Saves with `content_locale = "en"`
2. Automatically translates to Macedonian:
   - Name: "Летно Мени"
   - Description: "Свежи сезонски јадења"

### Example 2: Creating Content in Macedonian
When you switch to Macedonian and create a menu:
- Name: "Зимско Мени"
- Description: "Топли специјалитети"

The system:
1. Saves with `content_locale = "mk"`
2. Automatically translates to English:
   - Name: "Winter Menu"
   - Description: "Warm specialties"

### Viewing as a Customer
1. Customer scans QR code
2. Public menu page loads in English (default)
3. Customer clicks language toggle to switch to Macedonian
4. All content updates to show Macedonian translations

## Troubleshooting

### Translations Not Appearing
1. Check that background jobs are running (ActiveJob should be active)
2. Verify the DeepL API key is valid
3. Check Rails logs for translation errors:
   ```bash
   tail -f log/development.log
   ```

### API Rate Limits
The free Google Cloud Translation API has a limit of 500,000 characters per month. Monitor your usage at:
https://console.cloud.google.com/apis/api/translate.googleapis.com/quotas

### Manual Translation Trigger
To manually trigger translations for a record:
```ruby
# In Rails console
menu = Menu.first
menu.translate_name!(:mk)
menu.translate_description!(:mk)
```

## Files Modified/Created

### New Files
- `config/initializers/google_translate.rb` - Google Cloud Translation API configuration
- `app/models/translation.rb` - Translation model
- `app/models/concerns/translatable.rb` - Translatable concern with bidirectional support
- `app/jobs/translate_content_job.rb` - Background job for translations
- `db/migrate/[timestamp]_create_translations.rb` - Translations table
- `db/migrate/[timestamp]_add_content_locale_to_translatable_models.rb` - Content locale tracking

### Modified Files
- `Gemfile` - Added deepl-rb gem
- `config/application.rb` - Added ActiveJob configuration
- `app/models/menu.rb` - Added Translatable concern
- `app/models/section.rb` - Added Translatable concern
- `app/models/menu_item.rb` - Added Translatable concern
- `app/controllers/menus_controller.rb` - Added translation triggers
- `app/controllers/sections_controller.rb` - Added translation triggers
- `app/controllers/menu_items_controller.rb` - Added translation triggers
- `app/views/menus/public.html.erb` - Use translated content

## Future Enhancements

### Potential Improvements
1. **Admin Preview**: Add ability to preview translations before publishing
2. **Manual Override**: Allow manual editing of auto-translations
3. **More Languages**: Extend to support additional languages
4. **Translation Status**: Show translation progress/status in admin panel
5. **Batch Translation**: Translate multiple items at once
6. **Translation Cache**: Cache translations for better performance

## Support
For Google Cloud Translation API documentation: https://cloud.google.com/translate/docs
For issues or questions about this implementation, check the Rails logs and ensure all dependencies are installed.
