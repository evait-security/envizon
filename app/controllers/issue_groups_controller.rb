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
    @issue_group = IssueGroup.new(issue_group_params)

    respond_to do |format|
      if @issue_group.save
        format.html { redirect_to reports_path, notice: 'Issue group was successfully created.' }
        format.json { render :show, status: :created, location: @issue_group }
      else
        format.html { render :new }
        format.json { render json: @issue_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_groups/1
  # PATCH/PUT /issue_groups/1.json
  def update
    respond_to do |format|
      if @issue_group.update(issue_group_params)
        format.html { redirect_to reports_path, notice: 'Issue group was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_group }
      else
        format.html { render :edit }
        format.json { render json: @issue_group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_groups/1
  # DELETE /issue_groups/1.json
  def destroy
    @issue_group.destroy
    respond_to do |format|
      format.html { redirect_to reports_path, notice: 'Issue group was successfully destroyed.' }
      format.json { head :no_content }
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
end
