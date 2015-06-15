class CreateSupervisorCourses < ActiveRecord::Migration
  def change
    create_table :supervisor_courses do |t|

      t.timestamps null: false
    end
    add_reference :supervisor_courses, :course, null: false, foreign_key: true
    add_reference :supervisor_courses, :user , null: false, foreign_key: true
  end
end
