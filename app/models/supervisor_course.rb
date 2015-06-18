class SupervisorCourse < ActiveRecord::Base
  belongs_to :supervisor, class_name: 'User', foreign_key: :user_id
  belongs_to :course
end
