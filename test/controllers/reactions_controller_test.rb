require 'test_helper'

class ReactionsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    @other = users(:two)
    @post = posts(:one)
  end

  test 'reacting requires a signed in user' do
    assert_no_difference 'Reaction.count' do
      put post_reaction_path(@post), params: { kind: 'love' }
    end
    assert_redirected_to new_user_session_path

    assert_no_difference 'Reaction.count' do
      delete post_reaction_path(@post)
    end
    assert_redirected_to new_user_session_path
  end

  test 'a user can react to a post' do
    sign_in @user

    assert_difference 'Reaction.count', 1 do
      put post_reaction_path(@post), params: { kind: 'skull' }
    end

    assert_redirected_to root_path
    assert_equal 'skull', @post.reactions.find_by(user: @user).kind
  end

  test 'reacting again changes the reaction instead of adding one' do
    sign_in @other

    assert_no_difference 'Reaction.count' do
      put post_reaction_path(@post), params: { kind: 'laugh' }
    end

    assert_equal 'laugh', reactions(:two_loves_one).reload.kind
  end

  test 'an unknown kind is rejected' do
    sign_in @user

    assert_no_difference 'Reaction.count' do
      put post_reaction_path(@post), params: { kind: 'shrug' }
    end

    assert_response :unprocessable_entity
  end

  test "removing a reaction only removes the signed in user's" do
    @post.reactions.create!(user: @user, kind: 'fire')
    sign_in @user

    assert_difference 'Reaction.count', -1 do
      delete post_reaction_path(@post)
    end

    assert reactions(:two_loves_one).reload
  end

  test 'reacting over xhr re-renders the reactions row with the new count' do
    sign_in @user

    put post_reaction_path(@post), params: { kind: 'love' }, xhr: true

    assert_equal 'text/javascript', response.media_type
    assert_includes response.body, "getElementById('reactions_#{@post.id}').outerHTML"
    assert_includes response.body, 'Love, 2 reactions'
  end

  test 'the feed shows only used reactions and marks your own' do
    @post.reactions.create!(user: @user, kind: 'skull')
    sign_in @user

    get root_path

    assert_select "#reactions_#{@post.id}" do
      assert_select 'button.reaction', 2
      assert_select 'button.reaction[aria-label=?]', 'Love, 1 reaction'
      assert_select 'button.reaction.chosen[aria-pressed=true][aria-label=?]', 'Skull, 1 reaction'
      assert_select 'button.reaction[title=?]', @other.user_name
      assert_select '.picker button.picker-option', Reaction::KINDS.size
    end
  end

  test 'your own reaction removes itself when chosen again' do
    @post.reactions.create!(user: @user, kind: 'skull')
    sign_in @user

    get root_path

    # Rails sends DELETE as a hidden _method field on a POST form.
    assert_select "#reactions_#{@post.id} form:has(button.reaction.chosen) input[name=_method][value=delete]"
    assert_select "#reactions_#{@post.id} form:has(button.reaction[aria-label^=Love]) input[name=kind][value=love]"
  end
end
