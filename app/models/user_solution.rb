class UserSolution < ActiveRecord::Base

  # Validates
  validates :code, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :challenge
  belongs_to :user
end
