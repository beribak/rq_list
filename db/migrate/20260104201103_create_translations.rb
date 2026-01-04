class CreateTranslations < ActiveRecord::Migration[8.0]
  def change
    create_table :translations do |t|
      t.references :translatable, polymorphic: true, null: false
      t.string :field_name, null: false
      t.string :locale, null: false
      t.text :content

      t.timestamps
    end

    add_index :translations, [ :translatable_type, :translatable_id, :field_name, :locale ],
              unique: true, name: "index_translations_on_translatable_and_field_and_locale"
  end
end
