class Registration < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
  has_many :skill_scores

  accepts_nested_attributes_for :skill_scores, :reject_if => :all_blank

  serialize :groups, Hash

  def groups
    OpenStruct.new(self[:groups].as_json)
  end

  def build_course_skill_scores
    if self.skill_scores.count == 0
      self.course.skills.each do |skill|
        self.skill_scores.build(skill_id: skill.id)
      end
    end
  end
end
