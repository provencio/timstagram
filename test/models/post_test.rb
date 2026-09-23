require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      email: 'poster@example.com',
      user_name: 'poster',
      password: 'password'
    )
    @post = @user.posts.build(caption: 'A valid caption')
  end

  test 'is invalid without an attached image' do
    assert_not @post.valid?
    assert_includes @post.errors[:image], "can't be blank"
  end

  test 'is valid with an attached image' do
    attach_sample(@post)
    assert @post.valid?, @post.errors.full_messages.to_sentence
  end

  test 'rejects attachments that are not images' do
    @post.image.attach(
      io: StringIO.new('not an image'),
      filename: 'notes.txt',
      content_type: 'text/plain'
    )
    assert_not @post.valid?
    assert_includes @post.errors[:image], 'must be an image file'
  end

  test 'exposes a medium variant that is resized to 640px wide' do
    attach_sample(@post)
    @post.save!

    processed = @post.image.variant(:medium).processed
    variant = Vips::Image.new_from_buffer(processed.download, '')

    assert_equal 640, variant.width
  end

  private

  def attach_sample(post)
    post.image.attach(
      io: file_fixture('sample.png').open,
      filename: 'sample.png',
      content_type: 'image/png'
    )
  end
end
