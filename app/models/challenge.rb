class Challenge < ActiveRecord::Base

  # Validates
  validates :name, :presence => true
  validates :desc, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :chapter
  has_many :challenge_tabs
  has_many :hints
  has_many :user_solutions

  # RailsAdmin
  rails_admin do
    edit do
      field :name do
        label "Name"
        group :default
      end
      field :desc do
        label "Description"
        group :default
      end
      field :points do
        label "Challenge Point"
        group :default
      end
      field :chapter do
        label "Challenge Chapter"
        group :default
      end
      field :challenge_tabs do
        orderable true
      end
      field :hints do
        orderable true
      end
    end
  end
end
