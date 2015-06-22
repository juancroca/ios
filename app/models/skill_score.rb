class SkillScore < ActiveRecord::Base
  belongs_to :registration
  belongs_to :skill

  validates :skill, :registration, presence: true
end
