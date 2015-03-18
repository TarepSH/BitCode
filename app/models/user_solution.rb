class UserSolution < ActiveRecord::Base

  # Validates
  validates :code, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :challenge
  belongs_to :user

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :user
      field :challenge
      field :points
      field :code
    end
  end
end
