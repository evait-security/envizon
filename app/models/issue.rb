class Issue < ReportPart
  belongs_to :reportable, polymorphic: true

  def self.create_from_template(issueGroup, issueTemplate)
    Issue.create(
      reportable: issueGroup, 
      title: issueTemplate.title, 
      description: issueTemplate.description, 
      rating: issueTemplate.rating, 
      recommendation: issueTemplate.recommendation,
      severity: issueTemplate.severity ) 
  end
  
  def color
    case severity
    when 0
      return "green"
    when 1
        return "blue"
    when 2
        return "orange"
    when 3
        return "red"
    when 4
        return "purple"
    else
        return "grey"
    end  
  end
end
