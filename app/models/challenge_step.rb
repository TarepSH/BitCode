class ChallengeStep < ActiveRecord::Base

  # Validates
  validates :step_text, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :step_text
      field :challenge
    end
  end
end
