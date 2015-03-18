class Challenge < ActiveRecord::Base

  # Validates
  validates :name, :presence => true
  validates :desc, :presence => true
  validates :points, :presence => true

  # Relations
  belongs_to :chapter
  has_many :challenge_tabs, :dependent => :destroy
  has_many :challenge_steps
  has_many :hints, :dependent => :destroy
  has_many :user_solutions, :dependent => :destroy

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :desc
      field :points
      field :chapter
    end
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
      field :challenge_steps do
        orderable true
      end
      field :hints do
        orderable true
      end
    end
  end
  
  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

end
