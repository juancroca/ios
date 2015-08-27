class Group < ActiveRecord::Base
  belongs_to :course
  has_and_belongs_to_many :skills
  has_many :results
  has_many :students, ->{ uniq }, through: :results, class_name: "User", source: :user
  validates :name, presence: true, unless: "waiting_list?"
  validates :minsize, :maxsize, numericality: { only_integer: true, greater_than: 0}, unless: "waiting_list?"
  validate :sizes_validation, unless: "waiting_list?"

  scope :mandatory, -> {where(mandatory: true)}

  def to_builder
    Jbuilder.new do |group|
      group.id id
      group.minSize minsize
      group.maxSize maxsize
      group.skills skills.ids
      group.mandatory mandatory
      group.waitingList waiting_list
    end
  end

  def waiting_list?
    waiting_list
  end

  private
  def sizes_validation
    errors.add(:maxsize, "needs to be bigger than minimum size")if minsize && maxsize && (minsize > maxsize)
  end

end
