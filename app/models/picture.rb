class Picture < ApplicationRecord
  validates :image, presence: true, if: -> { video.blank? }
  validates :video, presence: true, if: -> { image.blank? }
  
  belongs_to :post
  belongs_to :user
  
  mount_uploader :image, ImageUploader
  mount_uploader :video, VideoUploader
end
