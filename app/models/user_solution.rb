class UserSolution < ActiveRecord::Base

  # Validates
  validates :points, :presence => true

  # Relations
  belongs_to :challenge
  belongs_to :user
  has_many :user_solution_tabs

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :user
      field :challenge
      field :points
      field :code
    end
  end

  # Methods
  after_save :increase_user_point

  private

  def increase_user_point
    user = self.user
    if (user.score)
      user.score += self.points
    else
      user.score = self.points
    end
    user.save
  end
end
