class IssueGroupsController < ApplicationController
  before_action :set_issue_group, only: [:show, :edit, :update, :destroy]

  # GET /issue_groups
  # GET /issue_groups.json
  def index
    @issue_groups = IssueGroup.all
  end

  # GET /issue_groups/1
  # GET /issue_groups/1.json
  def show
  end

  # GET /issue_groups/new
  def new
    @issue_group = IssueGroup.new
  end

  # GET /issue_groups/1/edit
  def edit
  end

  # POST /issue_groups
  # POST /issue_groups.json
  def create
    respond_to do |format|
      @issue_group = IssueGroup.new(issue_group_params)
      current_report = Report.first_or_create
      if @issue_group.save
        current_report.report_parts << @issue_group
        format.html { redirect_to reports_path, notice: 'Issue group was successfully created.' }
      else
        format.html { redirect_to reports_path, alert: 'Error while saving issue group' }
      end
    end
  end

  # PATCH/PUT /issue_groups/1
  # PATCH/PUT /issue_groups/1.json
  def update
    respond_to do |format|
      if @issue_group.update(issue_group_params)
        format.html { redirect_to reports_path, notice: 'Issue group was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /issue_groups/1
  # DELETE /issue_groups/1.json
  def destroy
    if @issue_group.report_parts.count > 0
      respond_with_notify("Issue group is not empty.","alert")
    else
      @issue_group.destroy
      respond_with_refresh("Issue group was successfully destroyed.", "success")
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_group
      @issue_group = IssueGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_group_params
      params.require(:issue_group).permit(:title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index)
    end

    def respond_with_refresh(message = 'Unknown error', type = 'alert', issue = 0)
      @current_report = Report.first_or_create
      @report_parts = @current_report.report_parts
      @report_parts_ig = ReportPart.where(type: "IssueGroup")
      @message = message
      @type = type
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'issues/refresh' }
      end
    end
end
