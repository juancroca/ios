class Job < ActiveRecord::Base
  belongs_to :course
  has_many :results
  has_many :students, ->{ uniq }, through: :results, class_name: "User", source: :user
  has_many :groups, ->{ uniq }, through: :results

  validate :registration_size

  scope :completed, -> {where(completed: true)}

  def registration_size
    errors.add(:base, "Registrations not enough for mandatory groups") if self.course.registrations.count < self.course.groups.mandatory.map(&:minsize).sum
  end

  def started?
    started
  end

  def completed?
    completed
  end

end
