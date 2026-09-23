class Post < ApplicationRecord

  validates :user_id, presence: true

  belongs_to :user

  has_many :comments, dependent: :destroy

  has_one_attached :image do |attachable|
    attachable.variant :medium, resize_to_limit: [640, nil]
  end

  validates :caption, length: { minimum: 3, maximum: 300 }
  validate :image_attached
  validate :image_is_an_image

  private

  def image_attached
    errors.add(:image, "can't be blank") unless image.attached?
  end

  def image_is_an_image
    return unless image.attached?

    unless image.content_type.to_s.start_with?('image/')
      errors.add(:image, 'must be an image file')
    end
  end
end
