class Registration < ActiveRecord::Base
  belongs_to :student, class_name: "User", foreign_key: :user_id
  belongs_to :course
  has_many :skill_scores

  accepts_nested_attributes_for :skill_scores

  serialize :groups, Hash
  serialize :friend_ids, Array

  def group_ids
    self.groups.map{|group| group[1]["id"]}
  end

  def build_course_skill_scores
    if self.skill_scores.count == 0
      (self.course.groups.map(&:skills).flatten + self.course.skills).uniq.each do |skill|
        self.skill_scores.build(skill_id: skill.id)
      end
    end
  end

  def to_builder
    Jbuilder.new do |registration|
      registration.id student.id
      registration.name student.name
      registration.mandatory compulsory || false
      registration.preferences group_ids
      registration.friends friend_ids
      registration.skills skill_scores.map{|ss| {"#{ss.skill.id}": ss.score}}
    end
  end
end
