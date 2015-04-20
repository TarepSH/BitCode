class UserSolutionTab < ActiveRecord::Base

  # Validates
  validates :code, :presence => true
  validates :name, :presence => true
  validates :language_name, :presence => true

  # Relations
  belongs_to :user_solution

  # RailsAdmin
  rails_admin do
    visible false
  end
end
