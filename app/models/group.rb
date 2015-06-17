class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :course

  validates :name, presence: true
  validates :minsize, :maxsize, numericality: { only_integer: true, greater_than: 0}
  validate :sizes_validation

  private
  def sizes_validation
    errors.add(:maxsize, "needs to be bigger than minimum size")if minsize > maxsize
  end

end
