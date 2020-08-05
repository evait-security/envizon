class IssueTemplatesController < ApplicationController
  before_action :set_issue_template, only: [:show, :edit, :update, :destroy]
  before_action :set_issue, only: [:create_from_issue]
  
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
