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
end
