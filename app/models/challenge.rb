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

      field :slug do
        label:"URL"
      end
    end
  end

  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Methods
  # {"h2": ["color", "font-size"]}|{"p": ["color", "background-color"]}
  def style_needed
    steps = self.challenge_steps
    h = Hash.new

    steps.each do |step|
      /"(.*)" tag has "(.*)" value for "(.*)" attribute/.match (step.step_text) do |res|
        if !h[res[1]]
          h[res[1]] = []
        end
        h[res[1]].push(res[3])
      end
    end
    h
  end

end
