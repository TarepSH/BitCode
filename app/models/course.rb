class Course < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300#", :thumb => "100x100#" }
  has_attached_file :cover

  # Validates
  validates :name, :presence => true
  validates :desc, :presence => true

  validates :logo, :attachment_presence => true
  validates :cover, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :logo
  validates_with AttachmentPresenceValidator, :attributes => :cover
  validates_with AttachmentSizeValidator, :attributes => :logo, :less_than => 2.megabytes
  validates_with AttachmentSizeValidator, :attributes => :cover, :less_than => 2.megabytes

  validates_attachment :logo, :presence => true,
    :content_type => {
      :content_type => [
        "image/jpg",
        "image/jpeg",
        "image/png"
      ]
    },
    :size => {
      :less_than => 2.megabytes
    }
  validates_attachment :cover, :presence => true,
    :content_type => {
      :content_type => [
        "image/jpg",
        "image/jpeg",
        "image/png"
      ]
    },
    :size => {
      :less_than => 2.megabytes
    }

  validate :logo_dimensions
  validate :cover_dimensions

  # Relations
  has_many :chapters, :dependent => :destroy

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :desc
      field :logo
      field :is_free
      field :published
      field :coming_soon
    end
  end

  # Methods
  def free?
    self.is_free
  end

  def coming_soon?
    self.coming_soon
  end

  private

    def logo_dimensions
      file_object = logo.queued_for_write[:original]

      unless file_object.blank?
        required_width  = 489
        required_height = 489
        dimensions = Paperclip::Geometry.from_file(file_object.path)

        errors.add(:logo, "dimensions must be #{required_width}x#{required_height}") unless dimensions.width == required_width && dimensions.height == required_height
      end
    end

    def cover_dimensions
      file_object = cover.queued_for_write[:original]

      unless file_object.blank?
        required_width  = 1370
        required_height = 700
        dimensions = Paperclip::Geometry.from_file(file_object.path)

        errors.add(:cover, "dimensions must be #{required_width}x#{required_height}") unless dimensions.width == required_width && dimensions.height == required_height
      end
    end

  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

end
