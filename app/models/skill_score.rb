class SkillScore < ActiveRecord::Base
  belongs_to :user
  belongs_to :skill
  belongs_to :owner, polymorphic: true
end
