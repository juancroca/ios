class Group < ActiveRecord::Base
  has_and_belongs_to_many :students, class_name: "User"
  belongs_to :course
  has_and_belongs_to_many :skills

  validates :name, presence: true
  validates :minsize, :maxsize, numericality: { only_integer: true, greater_than: 0}
  validate :sizes_validation

  private
  def sizes_validation
    errors.add(:maxsize, "needs to be bigger than minimum size")if minsize > maxsize
  end

end
