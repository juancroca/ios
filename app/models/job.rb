class Job < ActiveRecord::Base
  belongs_to :course
  has_many :results
  has_many :students, ->{ uniq }, through: :results, class_name: "User", source: :user
  has_many :groups, ->{ uniq }, through: :results

  accepts_nested_attributes_for :results

  validates_associated :results
  validate :registration_size

  scope :completed, -> {where(completed: true)}
  scope :selected, -> {where(selected: true).first}

  after_save :unique_job_selected

  def registration_size
    errors.add(:base, "Registrations not enough for mandatory groups") if self.course.registrations.count < self.course.groups.mandatory.map(&:minsize).sum
  end

  def started?
    started
  end

  def completed?
    completed
  end

  def get_groups
    hash = JSON.parse self.course.to_builder.target!
    hash[:courseId] = self.id #remove when json is updated
    hash[:jobId] = self.id #remove when json is updated
    hash[:id] = self.id
    endpoints = {
      success: Rails.application.routes.url_helpers.success_course_job_path(self.course, self),
      failure: Rails.application.routes.url_helpers.failure_course_job_path(self.course, self)
    }
    hash.merge!({endpoints: endpoints})
    connection.post '/run', hash.to_json
  end

  def update_groups
    hash = JSON.parse self.to_builder.target!
    hash[:id] = self.id
    endpoints = {
      success: Rails.application.routes.url_helpers.success_course_job_path(self.course, self),
      failure: Rails.application.routes.url_helpers.failure_course_job_path(self.course, self)
    }
    hash.merge!({endpoints: endpoints})
    connection.post '/run', hash.to_json
  end

  def to_builder
    Jbuilder.new do |job|
      job.id id
      job.groups groups.map{|g| {g.id => g.students.ids}.to_json}
      job.course course.to_builder.attributes!
    end
  end

  private
  def connection
    conn = Faraday.new(url: "http://scala:8080") do |faraday|
      faraday.headers['Content-Type'] = 'application/json'
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.request  :json
    end
  end

  def unique_job_selected
    self.course.jobs.where(selected: true).where.not(id: self.id).update_all(selected: false) if self.selected
  end

end
