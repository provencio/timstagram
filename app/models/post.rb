class Post < ApplicationRecord

  validates :user_id, presence: true

  belongs_to :user

  has_many :comments, dependent: :destroy
  has_many :reactions, dependent: :destroy

  has_one_attached :image do |attachable|
    attachable.variant :medium, resize_to_limit: [640, nil]
  end

  validates :caption, length: { minimum: 3, maximum: 300 }
  validate :image_attached
  validate :image_is_a_variable_image

  private

  def image_attached
    errors.add(:image, "can't be blank") unless image.attached?
  end

  # Posts are only ever rendered through their :medium variant, so accept just
  # the types Active Storage can actually transform. A plain `image/` prefix
  # check would let through formats like SVG that raise InvariableError at
  # render time. Active Storage identifies the type from the file's contents
  # when it is attached, so the client's declared content type is not trusted.
  def image_is_a_variable_image
    return unless image.attached?

    unless image.content_type.to_s.in?(ActiveStorage.variable_content_types)
      errors.add(:image, 'must be an image file (JPEG, PNG, GIF, WEBP, BMP, TIFF, ICO, HEIC or AVIF)')
    end
  end
end
