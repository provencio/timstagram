require 'test_helper'

class PostTest < ActiveSupport::TestCase
  SVG = %(<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"><script>alert(1)</script></svg>).freeze

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
    assert_match(/must be an image file/, @post.errors[:image].to_sentence)
  end

  test 'rejects image types Active Storage cannot turn into a variant' do
    @post.image.attach(
      io: StringIO.new(SVG),
      filename: 'evil.svg',
      content_type: 'image/svg+xml'
    )

    assert_not @post.image.variable?
    assert_not @post.valid?
    assert_match(/must be an image file/, @post.errors[:image].to_sentence)
  end

  test 'ignores the content type declared by the client' do
    # An SVG uploaded as image/png is identified from its contents on attach,
    # so it cannot sneak past the content type validation.
    @post.image.attach(
      io: StringIO.new(SVG),
      filename: 'evil.svg',
      content_type: 'image/png'
    )

    assert_equal 'image/svg+xml', @post.image.content_type
    assert_not @post.valid?
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
