class CreateSections < ActiveRecord::Migration[8.0]
  def change
    create_table :sections do |t|
      t.references :menu, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.integer :position, default: 0, null: false

      t.timestamps
    end
  end
end
