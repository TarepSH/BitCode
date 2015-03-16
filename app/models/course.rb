class Course < ActiveRecord::Base
  has_attached_file :logo, :styles => { :medium => "300x300#", :thumb => "100x100#" }

  validates :logo, :attachment_presence => true
  validates_with AttachmentPresenceValidator, :attributes => :logo
  validates_with AttachmentSizeValidator, :attributes => :logo, :less_than => 1.megabytes

  validates_attachment :logo, :presence => true,
    :content_type => {
      :content_type => [
        "image/jpg",
        "image/jpeg",
        "image/png"
      ]
    },
    :size => {
      :less_than => 1.megabytes
    }
end
