class Course < ActiveRecord::Base
  has_many :groups
  has_many :student_courses
  has_many :supervisor_courses
  has_many :students, through: :student_courses, source: :user
  has_many :supervisors, through: :supervisor_courses, source: :user

  accepts_nested_attributes_for :groups
end
