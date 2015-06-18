class Course < ActiveRecord::Base
  has_many :groups
  has_many :registrations
  has_many :supervisor_courses
  has_many :students, through: :registrations
  has_many :supervisors, through: :supervisor_courses
  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :groups, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :groups

  validates :isis_id, numericality: true
  validates :year, numericality: true, on: :update
  validates :name, :semester, presence: true, on: :update

  serialize :preferences, Hash

  SEMESTER = %w(ss ws)

  def preferences
    OpenStruct.new(self[:preferences].as_json)
  end
end
