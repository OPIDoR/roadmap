module TemplateHelper
  def links_to_a_elements(links, separator = ', ')
    a = links.map do |l|
      "<a href=\"#{l['link']}\">#{l['text']}</a>"
    end
    a.join(separator)
  end

  # TODO: to be removed upon merge with direct link feature
  # Generate a direct plan creation link with based on provided template
  # @param template [Template] template used for plan creation
  # @param hidden [Boolean] should the link be hidden ?
  # @param text [String] text for the link
  # @param id [String] HTML id for the link element
  def direct_link(template, hidden = false, text = nil, id = nil)
    params = { org_id: template.org.id, funder_id: '-1', template_id: template.id }
    cls = text.nil? ? 'direct-link' : 'direct-link btn btn-default'
    style = hidden ? 'display: none' : ''

    link_to(plans_url(plan: params), method: :post, title: _('Create plan'), class: cls, id: id, style: style) do
      if text.nil?
        '<span class="fa fa-plus-square"></span>'.html_safe
      else
        text.html_safe
      end
    end
  end
end
