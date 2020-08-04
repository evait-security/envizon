class IssueTemplatesController < ApplicationController
  before_action :set_issue_template, only: [:show, :edit, :update, :destroy]
  before_action :set_issue, only: [:create_from_issue]

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
  # todo: delete
  def new
    @issue_template = IssueTemplate.new
  end

  # GET /issue_templates/1/edit
  # todo: delete
  def edit
  end

  # GET /issue_templates/create_from_issue/1
  # todo: delete
  def create_from_issue
    issue_template = IssueTemplate.new
    issue_template.title = @issue.title
    issue_template.description = @issue.description
    issue_template.rating = @issue.rating
    issue_template.recommendation = @issue.recommendation
    issue_template.severity = @issue.severity
    if issue_template.save
      respond_with_notify("Issue template was successfully updated", "success")
    else
      respond_with_notify(issue_template.error, "error")
    end
  end

  # POST /issue_templates
  # POST /issue_templates.json
  # todo: delete
  def create
    issue_template = IssueTemplate.new(issue_template_params)

    respond_to do |format|
      if issue_template.save
        format.html { redirect_to issue_templates_path, notice: 'Issue template was successfully created.' }
      else
        format.html { redirect_to issue_templates_path, alert: issue_template.errors }
      end
    end
  end

  # PATCH/PUT /issue_templates/1
  # PATCH/PUT /issue_templates/1.json
  # todo: delete
  def update
    respond_to do |format|
      if @issue_template.update(issue_template_params)
        format.html { redirect_to issue_templates_path, notice: 'Issue template was successfully updated.' }
      else
        format.html { redirect_to issue_templates_path, alert: issue_template.errors }
      end
    end
  end

  # DELETE /issue_templates/1
  # DELETE /issue_templates/1.json
  # todo: delete
  def destroy
    @issue_template.destroy
    respond_to do |format|
      format.html { redirect_to issue_templates_url, notice: 'Issue template was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue_template
      @issue_template = IssueTemplate.find(params[:id])
    end

    def set_issue
      unless @issue = Issue.find_by_id(params[:issue_id])
        respond_with_notify("Value not found in DB", "alert")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_template_params
      params.require(:issue_template).permit(:title, :description, :rating, :recommendation, :severity)
    end
  
    def respond_with_notify(message = 'Unknown error', type = 'alert')
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'pages/notify', locals: { message: message, type: type } }
      end
    end
end
