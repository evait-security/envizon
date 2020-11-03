class IssuesController < ApplicationController
  before_action :set_issue, only: [:show, :edit, :update, :destroy, :update_template, :confirm_update_template, :new_template, :confirm_create_template, :link_client_form]
  before_action :set_mysql_client, only: [:confirm_update_template, :update_template, :new_template]
  before_action :set_client_and_issue, only: [:link_client]

  # GET /issues
  # GET /issues.json
  def index
    @issues = Issue.all
  end

  # GET /issues/1
  # GET /issues/1.json
  def show
  end

  def confirm_create_template
    @issue_template_remote = nil
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'issues/confirm_update_template' }
    end
  end

  # GET /issues/1/confirm_update_template/
  def confirm_update_template
    uid = @mysql_client.escape(@issue.uuid.to_s)
    begin
      rt = @mysql_client.query("SELECT * FROM issue_templates WHERE id=#{uid}")
      if rt.size == 1
        @issue_template_remote = rt.first
      else
        @issue_template_remote = nil
      end
    rescue => exception
      #respond_with_notify(exception.to_s, "alert")
      respond_with_notify("something went wrong with the mysql query: 90842", "alert")
      # redirect_back(fallback_location: root_path, alert: "something went wrong with the mysql connection2")
    end
  end

  def new_template
    title = @mysql_client.escape(@issue.title)
    description = @mysql_client.escape(@issue.description)
    rating = @mysql_client.escape(@issue.rating)
    recommendation = @mysql_client.escape(@issue.recommendation)
    severity = @mysql_client.escape(@issue.severity.to_s)
    begin
      @mysql_client.query("INSERT INTO issue_templates (title, description, rating, recommendation, severity) VALUES ('#{title}','#{description}','#{rating}','#{recommendation}','#{severity}')")
      
      # get the ID from the current insert.
      # the function `last_id` use the last inserted id from the current session, so it's thread save. 
      # https://stackoverflow.com/questions/8161211/get-affected-row-in-ruby-after-doing-an-insert-in-mysql
      @issue.uuid = @mysql_client.last_id
      @issue.save

      # create new local cached issue template (overwrite if uuid already exist)
      it = IssueTemplate.find_or_create_by(uuid: @issue.uuid)
      it.title = @issue.title
      it.description = @issue.description
      it.rating = @issue.rating
      it.recommendation = @issue.recommendation
      it.severity = @issue.severity
      it.save
    rescue => exception
      respond_with_notify("something went wrong with the mysql connection: 9080231", "alert")
    end
    respond_with_refresh("Issue was successfully synced to the remote database.", "success")
  end

  # GET /issues/1/update_template/
  def update_template
    uid = @mysql_client.escape(@issue.uuid.to_s)
    title = @mysql_client.escape(@issue.title)
    description = @mysql_client.escape(@issue.description)
    rating = @mysql_client.escape(@issue.rating)
    recommendation = @mysql_client.escape(@issue.recommendation)
    severity = @mysql_client.escape(@issue.severity.to_s)
    begin
      @mysql_client.query("UPDATE issue_templates SET title = '#{title}', description = '#{description}', rating = '#{rating}', recommendation = '#{recommendation}', severity = '#{severity}' WHERE id=#{uid}")
      
      # update local cached issue template (create if uuid didn't exist)
      it = IssueTemplate.find_or_create_by(uuid: @issue.uuid)
      it.title = @issue.title
      it.description = @issue.description
      it.rating = @issue.rating
      it.recommendation = @issue.recommendation
      it.severity = @issue.severity
      it.save
    rescue => exception
      respond_with_notify("something went wrong with the mysql connection: 2090203", "alert")
    end
    respond_with_refresh("Issue was successfully synced to the remote database.", "success")
  end

  # GET /issues/new
  def new
    @issue = Issue.new
    @issue_templates = IssueTemplate.all
  end

  # GET /issues/1/edit
  def edit
    @report_parts = ReportPart.where(type: "IssueGroup")
    case current_user.settings.where(name: 'report_mode').first_or_create.value
    when "presentation"
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'issues/present' }
      end
    else
    end
  end

  # POST /issues
  # POST /issues.json
  def create
    respond_to do |format|
      current_report = Report.first_or_create
      unless current_report.report_parts.empty?
        lastIssueGroup = current_report.report_parts.last
        if lastIssueGroup.type == "IssueGroup"
          if params.key?(:issue_template) && (IssueTemplate.exists? params[:issue_template])
            issue_clone = Issue.create_from_template(lastIssueGroup, IssueTemplate.find(params[:issue_template]))
            if (params.key?(:client) && client = Client.find_by_id(params[:client]))
              issue_clone.clients << client
            end
            format.html { redirect_to reports_path, notice: 'Issue was successfully created from template.' }
          else
            empty_issue_template = IssueTemplate.new
            empty_issue_template.title = "New blank issue"
            empty_issue_template.description = ""
            empty_issue_template.rating = ""
            empty_issue_template.recommendation = ""
            empty_issue_template.severity = -1
            empty_issue_template.uuid = 0

            Issue.create_from_template(lastIssueGroup, empty_issue_template)
            format.html { redirect_to reports_path, notice: 'New issue was created. Consider syncing it later.' }
          end
        else
          format.html { redirect_to reports_path, alert: 'Last report part is no issue group' }
        end
      else
        format.html { redirect_to reports_path, alert: 'No issue group found in current report. Please create a new one first.' }
      end
    end
  end

  # PATCH/PUT /issues/1
  # PATCH/PUT /issues/1.json
  def update
    if params[:issue][:screenshot].present?
      screenshot = @issue.screenshots.create
      screenshot.description = params[:issue][:screenshot][:description]
      screenshot.save
      screenshot.image.attach(params[:issue][:screenshot][:image])
    end
    if @issue.update(issue_params)
      respond_with_refresh("Issue was successfully updated.", "success")
    else
      respond_with_notify(@issue.errors, "alert")
    end
  end

  # DELETE /issues/1
  # DELETE /issues/1.json
  def destroy
    @issue.clients.delete_all
    @issue.screenshots.delete_all
    @issue.destroy
    respond_with_refresh("Issue was successfully destroyed.", "success")
  end

  def link_client_form
    if @issue
      @clients = Client.all
      respond_to do |format|
          format.html { redirect_back root_path }
          format.js { render 'issues/link_client' }
      end
    end
  end

  def link_client
    if @issue && @client
      @issue.clients << @client
      if @issue.save
        respond_with_notify("Client linked successfully - refresh needed","success")
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_issue
      unless @issue = Issue.find_by_id(params[:id])
        respond_with_notify("Value not found in DB", "alert")
      end
    end

    def set_client_and_issue
      unless @issue = Issue.find_by_id(params[:id])
        respond_with_notify("Value not found in DB", "alert")
      end
      unless @client = Client.find_by_id(params[:client])
        respond_with_notify("Value not found in DB", "alert")
      end      
    end

    def set_mysql_client
      begin
        @mysql_client = Mysql2::Client.new(JSON.parse(current_user.settings.where(name: 'mysql_connection').first_or_create.value))
      rescue => exception
        respond_with_notify(exception, "alert")
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def issue_params
      params.require(:issue).permit(:title, :severity, :description, :customtargets, :rating, :recommendation, :type, :index)
    end

    def screenshot_params
      params.require(:issue).require(:screenshot).permit(:image, :description, :order)
    end

    def respond_with_refresh(message = 'Unknown error', type = 'alert', issue = 0)
      @report_parts = ReportPart.where(type: "IssueGroup")
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'issues/refresh', locals: { message: message, type: type } }
      end
    end

    def respond_with_notify(message = 'Unknown error', type = 'alert')
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'pages/notify', locals: { message: message, type: type } }
      end
    end
end
