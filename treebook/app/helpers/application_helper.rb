module ApplicationHelper

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

  def can_display_status?(status)
    (signed_in? && !current_user.has_blocked?(status.user)) || !signed_in?
  end
end
