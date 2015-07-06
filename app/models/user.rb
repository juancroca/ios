class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :rememberable, :validatable, :trackable
  has_many :registrations
  has_many :supervisor_courses
  has_many :attending, through: :registrations, source: :course
  has_many :supervising, through: :supervisor_courses, source: :course

  validates :name, presence: true

  def password_required?
    false
  end

  def password
    false
  end

end
