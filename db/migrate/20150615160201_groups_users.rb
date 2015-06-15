class GroupsUsers < ActiveRecord::Migration
  def change
    create_table :groups_users do |table|
      table.timestamps null: false
    end
    add_reference :groups_users, :group, null: false, foreign_key: true
    add_reference :groups_users, :user , null: false, foreign_key: true
  end
end
