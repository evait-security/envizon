class Issue < ReportPart
  belongs_to :reportable, polymorphic: true
  belongs_to :issue_template, required: false

  def self.create_from_template(issue_group, issue_template)
    Issue.create(
      reportable: issue_group,
      title: issue_template.title,
      description: issue_template.description,
      rating: issue_template.rating,
      recommendation: issue_template.recommendation,
      severity: issue_template.severity,
      issue_template: issue_template
    )
  end

  def color
    case severity
    when 0
      'green'
    when 1
      'blue'
    when 2
      'orange'
    when 3
      'red'
    when 4
      'purple'
    else
      'grey'
    end
  end


  def color_hex
    case severity
    when 0
      '#3fb079;'
    when 1
      '#0b5394;'
    when 2
      '#b45f06;'
    when 3
      '#990000;'
    when 4
      '#9900ff;'
    else
      '#999999;'
    end
  end

  def colorize(text)
    result = text.gsub '<color>', "<strong><span style='color: #{color_hex}'>"
    result.gsub '</color>', "</span></strong>"
  end
  def clean_text(text)
=begin
    result = text.gsub '<color>', ""
    result.gsub '</color>', ""
    result = text.gsub '<i>', ""
    result.gsub '</i>', ""
=end
    ActionView::Base.full_sanitizer.sanitize(text.to_s)
  end
  
end
