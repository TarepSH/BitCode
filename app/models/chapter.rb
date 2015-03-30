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

  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

  # Methods
  def next
    Chapter.where('id > ?', self.id).order('id ASC').first
  end
end
