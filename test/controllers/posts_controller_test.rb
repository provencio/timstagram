require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @post = posts(:one)
    @post.image.attach(
      io: file_fixture('sample.png').open,
      filename: 'sample.png',
      content_type: 'image/png'
    )
    sign_in @user
  end

  test 'index renders the posts with their medium variant' do
    get root_path

    assert_response :success
    assert_select "img[src*='#{@post.image.variant(:medium).key}']"
  end

  test 'index still renders a legacy post that has no attachment' do
    assert_not posts(:two).image.attached?

    get root_path
    assert_response :success
  end

  test 'index survives a stored attachment that cannot be turned into a variant' do
    # A row that predates the content type allowlist: attached, but SVG, which
    # raises ActiveStorage::InvariableError if it reaches variant(:medium).
    legacy = posts(:two)
    legacy.image.attach(
      io: StringIO.new(%(<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10"/>)),
      filename: 'legacy.svg',
      content_type: 'image/svg+xml'
    )
    legacy.save!(validate: false)
    assert_not legacy.image.variable?

    get root_path
    assert_response :success
  end

  test 'show renders a single post' do
    get post_path(@post)
    assert_response :success
  end

  test 'edit renders the form for the owner' do
    get edit_post_path(@post)
    assert_response :success
  end

  test 'create stores an uploaded image' do
    assert_difference 'Post.count', 1 do
      post posts_path, params: {
        post: {
          caption: 'A brand new post',
          image: fixture_file_upload('sample.png', 'image/png')
        }
      }
    end

    assert_redirected_to posts_path
    assert Post.last.image.attached?
  end

  test 'create rejects a post without an image' do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { caption: 'No image here' } }
    end

    assert_response :success
  end
end
