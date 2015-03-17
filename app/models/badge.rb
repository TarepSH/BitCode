class Badge < ActiveRecord::Base
  has_attached_file :picture, :styles => { :medium => "200x200#", :thumb => "100x100#" }

  # Validates
  validates :name, :presence => true

  validates :picture, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :picture
  validates_with AttachmentSizeValidator, :attributes => :picture, :less_than => 500.kilobytes

  validates_attachment :picture, :presence => true,
    :content_type => {
      :content_type => [
        "image/jpg",
        "image/jpeg",
        "image/png"
      ]
    },
    :size => {
      :less_than => 500.kilobytes
    }

  validate :picture_dimensions

  # Relations
  belongs_to :chapter

  private

    def picture_dimensions
      required_width = required_height = 300
      dimensions = Paperclip::Geometry.from_file(picture.queued_for_write[:original].path)

      errors.add(:picture, "dimensions must be #{required_width}x#{required_height}") unless dimensions.width == required_width && dimensions.height == required_height
    end
end
