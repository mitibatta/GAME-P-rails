class Post < ApplicationRecord
  validates :user_id, presence:true
  validates :text, presence:true

  belongs_to :user
  has_many :pictures
  has_many :favorites
  has_many :comments
  accepts_nested_attributes_for :pictures
end
