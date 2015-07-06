class Result < ActiveRecord::Base
  belongs_to :job
  belongs_to :user
  belongs_to :group
end
