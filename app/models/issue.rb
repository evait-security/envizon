class Issue < ReportPart
  belongs_to :reportable, polymorphic: true
  has_many :notes, as: :noteable
  
  def self.create_from_template(issue_group, issue_template)
    Issue.create(
      reportable: issue_group,
      title: issue_template.title,
      description: issue_template.description,
      rating: issue_template.rating,
      recommendation: issue_template.recommendation,
      severity: issue_template.severity,
      uuid: issue_template.uuid
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
end
