class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true
  validates :name, :presence => true
  validates :email, :presence => true
  #validates :score, :presence => true

  # Relations
  has_many :user_solutions
  has_and_belongs_to_many :courses
  has_and_belongs_to_many :badges
  has_and_belongs_to_many :hints

  # Methods
  def admin?
    self.role == "admin"
  end

  def user?
    self.role == "user"
  end

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :username
      field :email
      field :role
    end
  end
end
