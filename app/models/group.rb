class Group < ActiveRecord::Base
  has_and_belongs_to_many :students, class_name: "User"
  belongs_to :course
  has_and_belongs_to_many :skills

  validates :name, presence: true
  validates :minsize, :maxsize, numericality: { only_integer: true, greater_than: 0}
  validate :sizes_validation

  def to_builder
    Jbuilder.new do |group|
      group.id id
      group.minSize minsize
      group.maxSize maxsize
      group.skills skills.ids
    end
  end

  private
  def sizes_validation
    errors.add(:maxsize, "needs to be bigger than minimum size")if minsize > maxsize
  end

end
