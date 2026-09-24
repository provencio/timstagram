class Reaction < ApplicationRecord
  # Display order in the feed and the picker.
  KINDS = {
    'love'      => 'Love',
    'laugh'     => 'Laugh',
    'skull'     => 'Skull',
    'fire'      => 'Fire',
    'wow'       => 'Wow',
    'sad'       => 'Sad',
    'thumbs_up' => 'Thumbs up'
  }.freeze

  belongs_to :user
  belongs_to :post

  validates :kind, inclusion: { in: KINDS.keys }
  validates :user_id, uniqueness: { scope: :post_id }
end
