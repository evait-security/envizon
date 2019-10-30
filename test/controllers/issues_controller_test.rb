require "test_helper"

describe IssuesController do
  let(:issue) { issues(:one) }

  it "should get index" do
    get issues_url
    must_respond_with :success
  end

  it "should get new" do
    get new_issue_url
    must_respond_with :success
  end

  it "should create issue" do
    assert_difference("Issue.count") do
      post issues_url, params: { issue: { customtargets: @issue.customtargets, description: @issue.description, index: @issue.index, rating: @issue.rating, recommendation: @issue.recommendation, severity: @issue.severity, title: @issue.title, type: @issue.type } }
    end

    must_redirect_to issue_url(Issue.last)
  end

  it "should show issue" do
    get issue_url(@issue)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_issue_url(@issue)
    must_respond_with :success
  end

  it "should update issue" do
    patch issue_url(@issue), params: { issue: { customtargets: @issue.customtargets, description: @issue.description, index: @issue.index, rating: @issue.rating, recommendation: @issue.recommendation, severity: @issue.severity, title: @issue.title, type: @issue.type } }
    must_redirect_to issue_url(issue)
  end

  it "should destroy issue" do
    assert_difference("Issue.count", -1) do
      delete issue_url(@issue)
    end

    must_redirect_to issues_url
  end
end
