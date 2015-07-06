class Group < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :skills
  has_many :results
  has_many :students, ->{ uniq }, through: :results, class_name: "User", source: :user
  validates :name, presence: true
  validates :minsize, :maxsize, numericality: { only_integer: true, greater_than: 0}
  validate :sizes_validation

  scope :mandatory, -> {where(mandatory: true)}

  def to_builder
    Jbuilder.new do |group|
      group.id id
      group.minSize minsize
      group.maxSize maxsize
      group.skills skills.ids
      group.mandatory mandatory
    end
  end

  private
  def sizes_validation
    errors.add(:maxsize, "needs to be bigger than minimum size")if minsize > maxsize
  end

end
