class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |table|
      table.string  :name
      table.integer :course_id, null:false, foreign_key: :course_id
      table.string  :description
      table.integer :minsize
      table.integer :maxsize
      table.boolean :waitingList, defalut: false;
      table.timestamps null: false
    end
  end
end
