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
end
