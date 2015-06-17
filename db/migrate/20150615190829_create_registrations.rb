class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.text :friend_ids
      t.text :groups
      t.boolean :compulsory
      t.timestamps null: false
    end
    add_reference :registrations, :course, null: false, foreign_key: true
    add_reference :registrations, :user , null: false, foreign_key: true
  end
end
