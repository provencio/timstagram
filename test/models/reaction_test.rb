require 'test_helper'

class ReactionTest < ActiveSupport::TestCase
  test 'accepts each known kind' do
    Reaction::KINDS.each_key do |kind|
      assert Reaction.new(user: users(:one), post: posts(:two), kind: kind).valid?, kind
    end
  end

  test 'rejects an unknown kind' do
    reaction = Reaction.new(user: users(:one), post: posts(:two), kind: 'shrug')

    assert_not reaction.valid?
    assert reaction.errors.added?(:kind, :inclusion, value: 'shrug')
  end

  test 'allows one reaction per user per post' do
    duplicate = Reaction.new(user: users(:two), post: posts(:one), kind: 'fire')

    assert_not duplicate.valid?
    assert_raises(ActiveRecord::RecordNotUnique) { duplicate.save(validate: false) }
  end

  test 'is removed with its post' do
    assert_difference 'Reaction.count', -1 do
      posts(:one).destroy
    end
  end
end
