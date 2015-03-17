class ChallengeTab < ActiveRecord::Base

  # Validates
  validates :name, :presence => true
  validates :language_name, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    visible false
  end
end
