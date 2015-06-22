class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |table|
      table.string :name
      table.string :semester
      table.string :description
      table.integer :year, default: Time.now.year
      table.datetime :enrollment_deadline
      table.integer :isis_id, unique: true
      table.boolean :visible, default: false
      table.boolean :closed, default: false
      table.text :preferences
      table.timestamps null: false
    end
  end
end
