module ApplicationHelper

	# Stroke icons drawn on a 24px grid; they take the surrounding text colour.
	ICONS = {
		plus:   '<path d="M12 5v14M5 12h14"/>',
		logout: '<path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3M10 17l5-5-5-5M15 12H4"/>',
		send:   '<path d="M5 12h14M13 6l6 6-6 6"/>',
		close:  '<path d="M6 6l12 12M18 6L6 18"/>',
		edit:   '<path d="M4 20h4L19 9l-4-4L4 16v4zM13.5 6.5l4 4"/>',
		upload: '<path d="M12 16V4M7 9l5-5 5 5"/><path d="M4 16v3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-3"/>'
	}.freeze

	def alert_for(flash_type)
  	    { success: 'alert-success',
    	    error: 'alert-danger',
    	    alert: 'alert-warning',
    	    notice: 'alert-info'
  	    }[flash_type.to_sym] || flash_type.to_s
	end

	def icon(name)
		tag.svg(ICONS.fetch(name).html_safe, class: 'icon', viewBox: '0 0 24 24', fill: 'none',
			stroke: 'currentColor', 'stroke-width': 2, 'stroke-linecap': 'round',
			'stroke-linejoin': 'round', 'aria-hidden': true)
	end

	def avatar_for(user)
		tag.div(user.user_name.first.upcase, class: ['avatar', "avatar-#{user.id % 6}"], 'aria-hidden': true)
	end

	# "now", "5m", "3h", "2d", then a date: the feed has little room for "about 3 hours ago".
	def short_time_ago(time)
		seconds = (Time.current - time).to_i
		text =
			if seconds < 1.minute then 'now'
			elsif seconds < 1.hour then "#{seconds / 1.minute}m"
			elsif seconds < 1.day then "#{seconds / 1.hour}h"
			elsif seconds < 1.week then "#{seconds / 1.day}d"
			elsif time.year == Time.current.year then time.strftime('%b %-d')
			else time.strftime('%b %-d, %Y')
			end
		tag.time(text, datetime: time.iso8601, title: time.to_fs(:long), class: 'time-ago')
	end

end
