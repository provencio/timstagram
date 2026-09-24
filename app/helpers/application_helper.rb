module ApplicationHelper

	# Stroke icons drawn on a 24px grid; they take the surrounding text colour.
	ICONS = {
		plus:   '<path d="M12 5v14M5 12h14"/>',
		logout: '<path d="M15 4h3a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2h-3M10 17l5-5-5-5M15 12H4"/>',
		send:   '<path d="M5 12h14M13 6l6 6-6 6"/>',
		close:  '<path d="M6 6l12 12M18 6L6 18"/>',
		edit:   '<path d="M4 20h4L19 9l-4-4L4 16v4zM13.5 6.5l4 4"/>',
		upload: '<path d="M12 16V4M7 9l5-5 5 5"/><path d="M4 16v3a1 1 0 0 0 1 1h14a1 1 0 0 0 1-1v-3"/>',
		add_reaction: '<path d="M20.5 11A8.5 8.5 0 1 1 13 3.5"/><path d="M8.5 14.5s1.2 2 3.5 2 3.5-2 3.5-2"/><path d="M9 9.5h.01M15 9.5h.01"/><path d="M19 2.5v5M16.5 5h5"/>',

		# One per Reaction::KINDS entry.
		love:      '<path d="M12 20s-7-4.35-7-10a4 4 0 0 1 7-2.65A4 4 0 0 1 19 10c0 5.65-7 10-7 10z"/>',
		laugh:     '<circle cx="12" cy="12" r="9"/><path d="M7.5 13.5s1.5 3 4.5 3 4.5-3 4.5-3z"/><path d="M8 9.5l2 1M16 9.5l-2 1"/>',
		skull:     '<path d="M12 3a8 8 0 0 0-8 8c0 2.6 1.2 4.4 3 5.5V20a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-3.5c1.8-1.1 3-2.9 3-5.5a8 8 0 0 0-8-8z"/><circle cx="9" cy="11.5" r="1.6"/><circle cx="15" cy="11.5" r="1.6"/><path d="M10.5 21v-2.5M13.5 21v-2.5"/>',
		fire:      '<path d="M12 21c-3.9 0-6.5-2.6-6.5-6.2 0-3.3 2.4-5.4 3.6-8.3.4 1.8 1.4 3 2.6 3.6-.1-2.6.9-5 3.1-7.1.3 3 3.7 5.4 3.7 11.3 0 3.9-2.7 6.7-6.5 6.7z"/>',
		wow:       '<circle cx="12" cy="12" r="9"/><path d="M9 9.5h.01M15 9.5h.01"/><circle cx="12" cy="15.5" r="2"/>',
		sad:       '<circle cx="12" cy="12" r="9"/><path d="M9 9.5h.01M15 9.5h.01"/><path d="M8.5 16.5s1.3-2 3.5-2 3.5 2 3.5 2"/>',
		thumbs_up: '<path d="M7 10v11H4a1 1 0 0 1-1-1v-9a1 1 0 0 1 1-1h3z"/><path d="M7 10l4-7a2.5 2.5 0 0 1 2.5 2.5V9h5.2a2 2 0 0 1 2 2.3l-1.3 8a2 2 0 0 1-2 1.7H7"/>'
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
