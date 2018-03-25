# frozen_string_literal: true
module DeviseHelper
  def devise_error_messages!
    return "" unless devise_error_messages?

    err = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    html = <<-HTML
    <ul>#{err}</ul>
    HTML

    html.html_safe
  end

  def devise_error_messages?
    !resource.errors.empty?
  end
end
