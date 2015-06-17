class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_and_belongs_to_many :groups
  has_many :student_courses
  has_many :supervisor_courses
  has_many :attending, through: :student_courses, source: :course
  has_many :supervising, through: :supervisor_courses, source: :course


  validates :name, presence: true
  
end
