class Course < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300#", :thumb => "100x100#" }

  # Validates
  validates :name, :presence => true
  validates :desc, :presence => true

  validates :logo, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :logo
  validates_with AttachmentSizeValidator, :attributes => :logo, :less_than => 2.megabytes

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

  validate :logo_dimensions

  # Relations
  has_many :chapters, :dependent => :destroy

  # RailsAdmin
  rails_admin do
    list do
      field :id
      field :name
      field :desc
      field :logo
      field :published
      field :coming_soon
    end
  end

  private

    def logo_dimensions
      file_object = logo.queued_for_write[:original]

      unless file_object.blank?
        required_width  = 1794
        required_height = 1200
        dimensions = Paperclip::Geometry.from_file(file_object.path)

        errors.add(:logo, "dimensions must be #{required_width}x#{required_height}") unless dimensions.width == required_width && dimensions.height == required_height
      end
    end

  #frindly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

end
