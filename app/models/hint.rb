class Hint < ActiveRecord::Base

  # Validates
  validates :title, :presence => true
  validates :desc, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :title
      field :desc
      field :points
      field :challenge
    end
  end
end
