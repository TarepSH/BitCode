class Hint < ActiveRecord::Base

  # Validates
  validates :title, :presence => true
  validates :desc, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :challenge

  # RailsAdmin
  rails_admin do
    visible false
  end
end
