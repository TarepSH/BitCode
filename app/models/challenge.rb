class Challenge < ActiveRecord::Base

  # Validates
  validates :name, :presence => true
  validates :desc, :presence => true

  # Relations
  belongs_to :chapter
  has_many :user_solutions
end
