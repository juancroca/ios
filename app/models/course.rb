class Course < ActiveRecord::Base
  has_many :groups
  has_many :registrations
  has_many :supervisor_courses
  has_many :students, through: :registrations
  has_many :supervisors, through: :supervisor_courses
  has_many :jobs
  has_and_belongs_to_many :skills

  accepts_nested_attributes_for :groups, :reject_if => :all_blank, :allow_destroy => true

  validates_associated :groups

  validates :isis_id, numericality: true
  validates :year, numericality: true, on: :update
  validates :name, :semester, presence: true, on: :update

  before_save :purge_study_fields

  serialize :preferences, Hash
  serialize :study_fields, Array

  scope :visible, -> {where(visible: true)}
  scope :open, -> {where(closed: false)}
  scope :closed, -> {where(closed: true)}

  SEMESTER = %w(ss ws)

  def preferences
    OpenStruct.new(self[:preferences].as_json)
  end

  def open?
    !closed
  end

  def closed?
    closed
  end

  def to_builder
    settings = Jbuilder.new do |settings|
      settings.diverse preferences.diverse || false
      settings.iterations preferences.iterations.to_i || 50
    end
    Jbuilder.new do |course|
      course.settings settings
      course.groups groups.map{|g| g.to_builder.attributes!}
      course.students registrations.map{|s| s.to_builder.attributes!}
    end
  end

  def create_groups
    job = self.jobs.build
    if job.save
      response = job.get_groups
      pp hash.to_json
      if response.status == 200
        self.update(closed: true)
        job.update(started: true)
      end
    end
    return job
  end

  private

  def purge_study_fields
    self.study_fields.flatten!
    self.study_fields.uniq!
    self.study_fields.delete("")
  end
end
