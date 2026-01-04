class AddContentLocaleToTranslatableModels < ActiveRecord::Migration[8.0]
  def change
    add_column :menus, :content_locale, :string, default: 'en'
    add_column :sections, :content_locale, :string, default: 'en'
    add_column :menu_items, :content_locale, :string, default: 'en'
  end
end
