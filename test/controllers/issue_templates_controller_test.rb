require "test_helper"

describe IssueTemplatesController do
  let(:issue_template) { issue_templates(:one) }

  it "should get index" do
    get issue_templates_url
    must_respond_with :success
  end

  it "should get new" do
    get new_issue_template_url
    must_respond_with :success
  end

  it "should create issue_template" do
    assert_difference("IssueTemplate.count") do
      post issue_templates_url, params: { issue_template: { description: @issue_template.description, rating: @issue_template.rating, recommendation: @issue_template.recommendation, severity: @issue_template.severity, title: @issue_template.title } }
    end

    must_redirect_to issue_template_url(IssueTemplate.last)
  end

  it "should show issue_template" do
    get issue_template_url(@issue_template)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_issue_template_url(@issue_template)
    must_respond_with :success
  end

  it "should update issue_template" do
    patch issue_template_url(@issue_template), params: { issue_template: { description: @issue_template.description, rating: @issue_template.rating, recommendation: @issue_template.recommendation, severity: @issue_template.severity, title: @issue_template.title } }
    must_redirect_to issue_template_url(issue_template)
  end

  it "should destroy issue_template" do
    assert_difference("IssueTemplate.count", -1) do
      delete issue_template_url(@issue_template)
    end

    must_redirect_to issue_templates_url
  end
end
