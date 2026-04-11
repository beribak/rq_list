class AddTemplateKeyToMenus < ActiveRecord::Migration[8.0]
  def change
    add_column :menus, :template_key, :string, null: false, default: "neon_noir"
  end
end
