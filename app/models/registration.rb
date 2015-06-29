class Registration < ActiveRecord::Base
  belongs_to :student, class_name: "User", foreign_key: :user_id
  belongs_to :course
  has_many :skill_scores

  accepts_nested_attributes_for :skill_scores, :reject_if => :all_blank

  serialize :groups, Hash
  serialize :friend_ids, Array


  def build_course_skill_scores
    if self.skill_scores.count == 0
      (self.course.groups.map(&:skills).flatten + self.course.skills).uniq.each do |skill|
        self.skill_scores.build(skill_id: skill.id)
      end
    end
  end

  def groups_normalized
    self.groups.inject({}){ |hash, (k, v)| hash.merge( k => v/10.0 )  }
  end

  def to_builder
    Jbuilder.new do |registration|
      registration.id student.id
      registration.name student.name
      registration.mandatory compulsory || false
      registration.preferences course.preferences.groups ? groups_normalized : []
      registration.friends course.preferences.friends ? friend_ids : []
      registration.skills skill_scores.map{|ss| {"#{ss.skill.id}": ss.score}}
    end
  end
end
