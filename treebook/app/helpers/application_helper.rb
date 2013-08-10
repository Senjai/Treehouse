module ApplicationHelper

	def can_display_status?(status)
		signed_in? && !current_user.has_blocked?(status.user) || !signed_in?
	end

	def avatar_profile_link(user, image_options={}, html_options={})
		link_to(image_tag(user.gravatar_url, image_options), profile_path(user.profile_name), html_options)
	end

	def page_header(&block)
		content_tag(:div, capture(&block), class: 'page-header')
	end

	def flash_class(type)
		case type
		when :alert
			"alert-error"
		when :notice
			"alert-success"
		else
			""
		end
	end
end
