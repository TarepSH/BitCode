class Badge < ActiveRecord::Base
  has_attached_file :picture, :styles => { :medium => "200x200#", :thumb => "100x100#" }

  # Validates
  validates :name, :presence => true
  validates :points, :presence => true

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

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :picture
      field :chapter
    end
  end

  private

    def picture_dimensions
      file_object = picture.queued_for_write[:original]

      unless file_object.blank?
        required_width = required_height = 300
        dimensions = Paperclip::Geometry.from_file(file_object.path)

        errors.add(:picture, "dimensions must be #{required_width}x#{required_height}") unless dimensions.width == required_width && dimensions.height == required_height
      end
    end
end
