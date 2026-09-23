require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other = users(:two)
    @post = posts(:one)
    @comment = comments(:one)
  end

  test 'create requires a signed in user' do
    assert_no_difference 'Comment.count' do
      post post_comments_path(@post), params: { comment: { content: 'Hello' } }
    end

    assert_redirected_to new_user_session_path
  end

  test 'destroy requires a signed in user' do
    assert_no_difference 'Comment.count' do
      delete post_comment_path(@post, @comment)
    end

    assert_redirected_to new_user_session_path
  end

  test 'a signed in user can comment' do
    sign_in @user

    assert_difference 'Comment.count', 1 do
      post post_comments_path(@post), params: { comment: { content: 'Nice shot' } }
    end

    assert_equal @user.id, Comment.last.user_id
    assert_redirected_to root_path
  end

  test 'the comment author is taken from the session, not the params' do
    sign_in @user

    post post_comments_path(@post), params: {
      comment: { content: 'Spoofed', user_id: @other.id }
    }

    assert_equal @user.id, Comment.last.user_id
  end

  test 'a user can delete their own comment' do
    sign_in @user

    assert_difference 'Comment.count', -1 do
      delete post_comment_path(@post, @comment)
    end

    assert_redirected_to root_path
  end

  test "a user cannot delete someone else's comment" do
    sign_in @other

    assert_no_difference 'Comment.count' do
      delete post_comment_path(@post, @comment)
    end

    assert_redirected_to root_path
    assert_equal "That comment doesn't belong to you!", flash[:alert]
  end
end
