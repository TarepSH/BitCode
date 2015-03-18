class Chapter < ActiveRecord::Base
  has_attached_file :video

  # Validates
  validates :title, :presence => true

  validates :video, :attachment_presence => true

  validates_with AttachmentPresenceValidator, :attributes => :video

  validates_attachment :video, :presence => true,
    :content_type => {
      :content_type => [
        "video/mp4",
        "video/ogg"
      ]
    }

  # Relations
  belongs_to :course
<<<<<<< HEAD
  has_many :challenges
  has_many :badges

  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

=======
  has_many :challenges, :dependent => :destroy
  has_many :badges, :dependent => :destroy

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :title
      field :desc
      field :video
      field :course
    end
  end
>>>>>>> 49f7b74d04c9361c173f8d461bcf27e2c3eacba0
end
