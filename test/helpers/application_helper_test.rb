require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test 'short_time_ago abbreviates recent times and falls back to a date' do
    travel_to Time.zone.local(2026, 9, 23, 12, 0, 0) do
      assert_includes short_time_ago(30.seconds.ago), '>now<'
      assert_includes short_time_ago(5.minutes.ago), '>5m<'
      assert_includes short_time_ago(3.hours.ago), '>3h<'
      assert_includes short_time_ago(2.days.ago), '>2d<'
      assert_includes short_time_ago(Time.zone.local(2026, 3, 4)), '>Mar 4<'
      assert_includes short_time_ago(Time.zone.local(2025, 3, 4)), '>Mar 4, 2025<'
    end
  end

  test 'avatar_for shows the initial with a colour fixed by user id' do
    user = users(:one)

    assert_dom_equal %(<div class="avatar avatar-#{user.id % 6}" aria-hidden="true">U</div>), avatar_for(user)
  end
end
