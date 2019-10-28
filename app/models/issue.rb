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
    when 0..999
      return "green"
    when 1000..1999
        return "blue"
    when 2000..2999
        return "orange"
    when 3000..3999
        return "red"
    when 4000..4999
        return "purple"
    else
        return "grey"
    end  
  end
end
