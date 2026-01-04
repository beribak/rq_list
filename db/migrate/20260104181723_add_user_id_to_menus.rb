class AddUserIdToMenus < ActiveRecord::Migration[8.0]
  def change
    add_reference :menus, :user, null: true, foreign_key: true
    
    # Assign existing menus to the first user (or create one if none exist)
    reversible do |dir|
      dir.up do
        user = User.first || User.create!(email: 'admin@example.com', password: 'password123')
        Menu.update_all(user_id: user.id)
      end
    end
    
    change_column_null :menus, :user_id, false
  end
end
