class IssueTemplatesController < ApplicationController
  before_action :set_issue_template, only: [:show, :edit, :update, :destroy]

  # GET /issue_templates
  # GET /issue_templates.json
  def index
    @issue_templates = IssueTemplate.all.order(:title)
  end

  # POST /issue_templates/search
  def search 
    @issue_templates = IssueTemplate.where('lower(title) LIKE :search or lower(description) LIKE :search', search: "%#{params["title"].downcase}%")
    respond_to do |format|
      format.js { render :search_result }
    end
  end

  # POST /issue_templates/search_add
  # Used if searched from add new issue page (output has to be a little bit different)
  def search_add
    if params.key?(:client)
      @client = Client.find(params[:client])
    end
    @issue = Issue.new
    @issue_templates = IssueTemplate.where('lower(title) LIKE :search or lower(description) LIKE :search', search: "%#{params["title"].downcase}%")
    respond_to do |format|
      format.js { render :search_result_add }
    end
  end

  # GET /issue_templates/new
  def new
    @issue_template = IssueTemplate.new
  end

  # GET /issue_templates/1/edit
  def edit
  end

  # POST /issue_templates
  # POST /issue_templates.json
  def create
    @issue_template = IssueTemplate.new(issue_template_params)

    respond_to do |format|
      if @issue_template.save
        format.html { redirect_to issue_templates_path, notice: 'Issue template was successfully created.' }
        format.json { render :show, status: :created, location: @issue_template }
      else
        format.html { render :new }
        format.json { render json: @issue_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /issue_templates/1
  # PATCH/PUT /issue_templates/1.json
  def update
    respond_to do |format|
      if @issue_template.update(issue_template_params)
        format.html { redirect_to issue_templates_path, notice: 'Issue template was successfully updated.' }
        format.json { render :show, status: :ok, location: @issue_template }
      else
        format.html { render :edit }
        format.json { render json: @issue_template.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issue_templates/1
  # DELETE /issue_templates/1.json
  def destroy
    @issue_template.destroy
    respond_to do |format|
      format.html { redirect_to issue_templates_url, notice: 'Issue template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_template
      @issue_template = IssueTemplate.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_template_params
      params.require(:issue_template).permit(:title, :description, :rating, :recommendation, :severity)
    end
end
