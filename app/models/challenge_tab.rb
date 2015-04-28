class ChallengeTab < ActiveRecord::Base

  # Validates
  validates :name, :presence => true
  validates :language_name, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :language_name
      field :starter_code
      field :challenge
    end
  end
end
