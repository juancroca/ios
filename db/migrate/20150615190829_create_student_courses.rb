class CreateStudentCourses < ActiveRecord::Migration
  def change
    create_table :student_courses do |t|

      t.timestamps null: false
    end
    add_reference :student_courses, :course, null: false, foreign_key: true
    add_reference :student_courses, :user , null: false, foreign_key: true
  end
end
