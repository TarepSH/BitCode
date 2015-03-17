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
  has_many :challenges
  has_many :badges
end
