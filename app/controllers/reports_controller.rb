require "sablon"
class ReportsController < ApplicationController
  before_action :set_report, only: [:show, :edit, :update, :destroy, :export_docx]

  # GET /reports
  # GET /reports.json
  def change_parent
    source_param = params[:source]
    new_parent_param = params[:new_parent]
    if source_param.to_i == new_parent_param.to_i
      respond_with_notify('Source and parent are identical.', "alert")
      return
    end
        
    if (ReportPart.exists? source_param)
      unless (ReportPart.exists? new_parent_param)
        # IF parent not exists, source moved directly to report
        @current_report_setting = current_user.settings.find_by_name('current_report').value
        if Report.exists? @current_report_setting
          new_parent = Report.find(@current_report_setting)
          new_parent.report_parts << ReportPart.find(source_param)
          respond_with_refresh("Parent was successfully changed.", "success")
        else
          respond_with_notify('Current report is not in database.', "alert")
          return
        end
      else
        source = ReportPart.find(source_param)
        new_parent = ReportPart.find(new_parent_param)
        new_parent.report_parts << source
        respond_with_refresh("Parent was successfully changed.", "success")
      end
    else
      respond_with_notify('Source not exists as report part.', "alert")
      return
    end
  end

  def index
    @new_report = Report.new
    @reports = Report.all

    if @reports.present?
      if current_user.settings.where(name: 'current_report').present?
        @current_report = current_user.settings.find_by_name('current_report').value
        unless Report.exists? @current_report
          setting = current_user.settings.find_by_name('current_report')
          setting.value = Report.first.id
          setting.save!
          @current_report = setting.value
        end
      else
        setting = current_user.settings.where(name: 'current_report').first_or_create
        setting.value = Report.first.id
        setting.save!
        @current_report = setting.value
      end
    end
  end

  # GET /reports/1
  # GET /reports/1.json
  def show
  end

  # GET /reports/1/edit
  def edit
  end

  # POST /reports
  # POST /reports.json
  def create
    @report = Report.new(report_params)

    respond_to do |format|
      if @report.save
        setting = current_user.settings.where(name: 'current_report').first_or_create
        setting.value = @report.id
        setting.save!
        format.html { redirect_to reports_path, notice: 'Report was successfully created and selected as current.' }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    respond_to do |format|
      if @report.update(report_params)
        format.html { redirect_to @report, notice: 'Report was successfully updated.' }
        format.json { render :show, status: :ok, location: @report }
      else
        format.html { render :edit }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reports/1
  # DELETE /reports/1.json
  def destroy
    @report.destroy
    respond_to do |format|
      format.html { redirect_to reports_url, notice: 'Report was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def export_docx
    # init template files
    FileUtils.mkdir_p('/usr/src/app/envizon/report-templates')
    report_filne_name = "Report Pentest - #{@report.title} #{Date.today.year}"
    output_file = File.new(Rails.root.join('tmp') + "#{report_filne_name}.docx", 'w')
    template = Sablon.template(File.expand_path("/usr/src/app/envizon/report-templates/evait.docx"))

    # init template context
    context = {
      title: report_filne_name,
      report: OpenStruct.new(
        :summary => @report.summary,
        :conclusion => @report.conclusion,
        :contact_person => @report.contact_person,
        :company_name => @report.company_name,
        :street => @report.street,
        :postalcode => @report.postalcode,
        :city => @report.city)
    }

    # generate docx and let them download
    template.render_to_file output_file, context
    send_file output_file, filename: "#{report_filne_name}.docx", type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    nil
=begin 
    report_docx = ODFReport::Report.new("/usr/src/app/envizon/report-templates/evait.docx") do |r|
      r.add_field :summary, @report.summary
      r.add_field :conclusion, @report.conclusion
      r.add_field :contact_person, @report.contact_person
      r.add_field :company_name, @report.company_name
      r.add_field :street, @report.street
      r.add_field :postalcode, @report.postalcode
      r.add_field :city, @report.city
      
      sc_group_index = 0
      issue_groups = @report.report_parts.select{|rp| rp.is_a? IssueGroup}
      r.add_section("SC_ISSUEGROUP", issue_groups) do |sc_group|
        cur_ig = @report.report_parts[sc_group_index]
        sc_group.add_field(:ig_index) {(sc_group_index + 1).to_s}
        sc_group.add_field(:ig_title) {|ig| ig.title}
        #{|ig| issues = ig.report_parts.select{|rp| rp.is_a? IssueGroup}}
        
        sc_issue_index = 0
        issues = cur_ig.report_parts.select{|rp| rp.is_a? Issue}
        sc_group.add_section("SC_ISSUE", :report_parts ) do |sc_issue|
          sc_group.add_field(:issue_title) {|issue| issue.title}
          #sc_group.add_field(:issue_description) {|issue| issue.description}
          #sc_group.add_field(:issue_rating) {|issue| issue.rating}
          #sc_group.add_field(:issue_recommendation) {|issue| issue.recommendation}

          sc_issue_index += 1
        end
        
        sc_group_index += 1
      end

      sc_group_index = 0
      issue_groups = @report.report_parts.select{|rp| rp.is_a? IssueGroup}
      r.add_section("SC_ISSUEGROUP", issue_groups) do |sc_group|
        sc_group.add_field(:ig_index, (sc_group_index + 1).to_s)
        sc_group.add_field(:ig_title) {|ig| ig.title}

       
        issues = issue_groups[sc_group_index].report_parts.select{|rp| rp.is_a? IssueGroup}
        sc_issue_index = 0
        sc_group.add_section("SC_ISSUE", issues ) do |sc_issue|
          sc_group.add_field(:issue_title) {|issue| issue.title}
          sc_group.add_field(:issue_description) {|issue| issue.description}
          sc_group.add_field(:issue_rating) {|issue| issue.rating}
          sc_group.add_field(:issue_recommendation) {|issue| issue.recommendation}

          sc_issue_index += 1
        end

        sc_group_index += 1
      end   
    end

    report_odt.generate(output_file)
=end   
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def report_params
      params.require(:report).permit(:summary, :conclusion, :logo_url, :contact_person, :company_name, :street, :postalcode, :city, :title)
    end

    def respond_with_refresh(message = 'Unknown error', type = 'alert', issue = 0)
      respond_to do |format|
        format.html { redirect_to root_path }
        # yes...ofc. this is ugly. #quick&dirty 
        # there exists no routine atm to reload the sidebar
        format.js { render :js => "window.location.href='" + reports_path + "'" }
      end
    end
    def respond_with_notify(message = 'Unknown error', type = 'alert')
      respond_to do |format|
        format.html { redirect_to root_path }
        format.js { render 'pages/notify', locals: { message: message, type: type } and return}
      end
    end
end
