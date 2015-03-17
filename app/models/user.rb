class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :username, :presence => true
  validates :name, :presence => true
  #validates :score, :presence => true

  has_and_belongs_to_many :courses

  def admin?
    self.role == "admin"
  end

  def user?
    self.role == "user"
  end
end
