class ChallengeStep < ActiveRecord::Base

  # Validates
  validates :step_text, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    visible false
  end
end
