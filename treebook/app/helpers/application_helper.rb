module ApplicationHelper

  def status_document_link(status)
    if status.document && status.document.attachment?
      html = ""
      html << content_tag(:span, "Attachment", class: "label label-info")
      html << link_to(status.document.attachment_file_name, status.document.attachment.url)
      html.html_safe
    end
  end

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
