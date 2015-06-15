class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |table|
      table.string :name;
      table.integer :isis_id, unique: true;
      table.timestamps null: false
    end
  end
end
