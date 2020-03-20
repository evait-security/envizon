require "test_helper"

describe IssueGroupsController do
  let(:issue_group) { issue_groups(:one) }

  it "should get index" do
    get issue_groups_url
    must_respond_with :success
  end

  it "should get new" do
    get new_issue_group_url
    must_respond_with :success
  end

  it "should create issue_group" do
    assert_difference("IssueGroup.count") do
      post issue_groups_url, params: { issue_group: { customtargets: @issue_group.customtargets, description: @issue_group.description, index: @issue_group.index, rating: @issue_group.rating, recommendation: @issue_group.recommendation, severity: @issue_group.severity, title: @issue_group.title, type: @issue_group.type } }
    end

    must_redirect_to issue_group_url(IssueGroup.last)
  end

  it "should show issue_group" do
    get issue_group_url(@issue_group)
    must_respond_with :success
  end

  it "should get edit" do
    get edit_issue_group_url(@issue_group)
    must_respond_with :success
  end

  it "should update issue_group" do
    patch issue_group_url(@issue_group), params: { issue_group: { customtargets: @issue_group.customtargets, description: @issue_group.description, index: @issue_group.index, rating: @issue_group.rating, recommendation: @issue_group.recommendation, severity: @issue_group.severity, title: @issue_group.title, type: @issue_group.type } }
    must_redirect_to issue_group_url(issue_group)
  end

  it "should destroy issue_group" do
    assert_difference("IssueGroup.count", -1) do
      delete issue_group_url(@issue_group)
    end

    must_redirect_to issue_groups_url
  end
end
