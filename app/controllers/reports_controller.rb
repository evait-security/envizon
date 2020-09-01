require 'sablon'
class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy export_docx export_verinice]

  # GET /reports
  # GET /reports.json
  def change_parent
    source_param = params[:source]
    new_parent_param = params[:new_parent]
    if source_param.to_i == new_parent_param.to_i
      respond_with_notify('Source and parent are identical.', 'alert')
      return
    end

    if ReportPart.exists? source_param
      if ReportPart.exists? new_parent_param
        source = ReportPart.find(source_param)
        new_parent = ReportPart.find(new_parent_param)
        new_parent.report_parts << source
      else
        # IF parent not exists, source moved directly to report
        new_parent = Report.first_or_create
        new_parent.report_parts << ReportPart.find(source_param)
      end
      respond_with_refresh('Parent was successfully changed.', 'success')
    else
      respond_with_notify('Source not exists as report part.', 'alert')
      nil
    end
  end

  def index
    @current_report = Report.first_or_create
    @report_parts = @current_report.report_parts
  end

  # GET /reports/1
  # GET /reports/1.json
  def show; end

  # GET /reports/1/edit
  def edit; end

  # PATCH/PUT /reports/1
  # PATCH/PUT /reports/1.json
  def update
    return unless @report.update(report_params)

    respond_with_notify('Report was successfully updated.', 'success')
    nil
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

  # GET|POST /reports/1/export_docx
  def export_docx
    # init template files
    template_path = Rails.root.join('report-templates')
    FileUtils.mkdir_p(template_path)
    report_file_name = "Report Pentest - #{@report.title} #{Date.today.year}"
    output_file = File.new(Rails.root.join('tmp') + "#{report_file_name}.docx", 'w')

    Sablon.configure do |config|
      config.register_html_tag(:code, :inline,
                               properties: { rFonts: { ascii: 'Roboto Mono', cs: 'Roboto Mono' } })
    end
    template = Sablon.template(File.expand_path(Rails.root.join(template_path, 'envizon_template.docx')))

    # init strukts
    s_report = Struct.new(:item, :summary, :conclusion, :issue_groups)
    s_issue_group = Struct.new(:item, :index, :issues)
    s_issue = Struct.new(:item, :index, :targets, :description, :rating, :recommendation, :screenshots)
    s_image = Struct.new(:item, :index, :description, :pix)
    # Sablon.content(:image, string_io_obj)
    # init template context
    context = {
      title: report_file_name,
      report: s_report.new(
        @report, # report.summary
        Sablon.content(:html, <<-HTML.strip
        #{Report.prepare_text_docx(@report.summary)}
        HTML
        ), # report.conclusion
        Sablon.content(:html, <<-HTML.strip
        #{Report.prepare_text_docx(@report.conclusion)}
        HTML
        ), # report.issue_groups->issues->description
        @report.report_parts.order(:index).select { |rp| rp.is_a? IssueGroup }.each_with_index.map do |ig, index_ig| # report.issue_groups
          s_issue_group.new(
            ig, # report.issue_groups->item
            index_ig, # report.issue_groups->index
            ig.ordered_child_issues.each_with_index.map do |issue, index_issue| # report.issue_groups->issues
              s_issue.new(
                issue, # report.issue_groups->issues->item
                index_issue, # report.issue_groups->issues->index
                (issue.clients.map { |c| c.ip.to_s + (c.hostname.present? ? " (#{c.hostname})" : '') } + (issue.customtargets.present? ? issue.customtargets.lines : [])).map(&:strip).reject(&:empty?), # report.issue_groups->issues->targets
                Sablon.content(:html, <<-HTML.strip
                #{Report.prepare_text_docx(issue.description)}
                HTML
                ), # report.issue_groups->issues->description
                Sablon.content(:html, <<-HTML.strip
                #{Report.prepare_text_docx(issue.rating)}
                HTML
                ), # report.issue_groups->issues->rating
                Sablon.content(:html, <<-HTML.strip
                #{Report.prepare_text_docx(issue.recommendation)}
                HTML
                ), # report.issue_groups->issues->recommendation
                issue.screenshots.each_with_index.map do |screenshot, index_screenshot|
                  s_image.new( # report.issue_groups->issues->screenshots
                    screenshot, # report.issue_groups->issues->screenshots->item
                    index_screenshot, # report.issue_groups->issues->screenshots->index
                    screenshot.description, # report.issue_groups->issues->screenshots->description
                    # Sablon.content(:image, '/usr/src/app/envizon/report-templates/test.png', properties: {height: '2cm', width: '2cm'})  #report.issue_groups->issues->screenshots->content
                    Sablon.content(:image, StringIO.new(IO.binread(ActiveStorage::Blob.service.send(:path_for, screenshot.image.key))), filename: 'test.png', properties: { height: "#{screenshot.size_relation * 16.08}cm", width: '16.08cm' }) # report.issue_groups->issues->screenshots->content
                    # use params like:
                    # Sablon.content(:image, 'path', filename: 'test.png', properties: {height: '2cm', width: '2cm'})
                  )
                end
              )
            end
          )
        end
      )
    }

    # generate docx and let them download
    template.render_to_file output_file, context
    send_file output_file, filename: "#{report_file_name}.docx", type: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    nil
  end

  def export_verinice
    report_file_name = "Verinice Report Pentest - #{@report.title} #{Date.today.year}"
    output_file = File.new(Rails.root.join('tmp') + "#{report_file_name}.xml", 'w')

    @verinice_ids = []
    @rand = Random.new
    template_path = Rails.root.join('report-templates', 'evait_verinice.xml.erb')

    issues = @report.all_issues

    targets_ids = {}
    issue_ids = {}
    issues_to_targets = {}

    issues.each do |issue|
      en_issue = verinice_entity
      issue_ids[issue.id] = en_issue
      issues_to_targets[en_issue] = []
      # map linked clients
      issue.clients.each do |clients|
        en_clients = verinice_entity
        targets_ids[clients.id] = en_clients
        issues_to_targets[en_issue] << en_clients
      end
      # map custom targets
      issue.customtargets.lines.each do |c_targets|
        en_clients = verinice_entity
        targets_ids[c_targets] = en_clients
        issues_to_targets[en_issue] << en_clients
      end
    end

    # issue.clients.map{|c| c.ip.to_s + (c.hostname.present? ? " (#{c.hostname})" : '')} + (issue.customtargets.present? ? issue.customtargets.lines : [])

    erb = ERB.new(File.read(template_path), nil, '<>-')
    res = erb.result(binding)
    # remove empty lines:
    res = res.lines.reject { |s| s.strip.empty? }.join

    # replace unicode-chars which verinice doesn't like
    res = res.gsub(/newline\..*\n/, '').gsub(/[„“”]/, '"').gsub('–', '-')

    # remove/reformat hN. tags and %-span-syntax
    res = res.gsub(/(h\d\.\s([\w|\s]+)\n)/, "\n\n\\2\n\n")
             .gsub(/(%\(\w+\)(\w+)%)/, '\2')

    raise 'xml errors!' unless Nokogiri::XML(res).errors.length.zero?

    File.delete(output_file) if File.exist?(output_file)
    File.open(output_file, 'w') { |f| f.write(res) }
    send_file output_file, filename: "#{report_file_name}.xml", type: 'application/xml'
    nil
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_report
    @report = Report.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def report_params
    params.require(:report).permit(:summary, :conclusion, :logo_url, :contact_person,
                                   :company_name, :street, :postalcode, :city, :title)
  end

  def respond_with_refresh(_message = 'Unknown error', _type = 'alert', _issue = 0)
    respond_to do |format|
      format.html { redirect_to root_path }
      # yes...ofc. this is ugly. #quick&dirty
      # there exists no routine atm to reload the sidebar
      format.js { render js: "window.location.href='" + reports_path + "'" }
    end
  end

  def respond_with_notify(message = 'Unknown error', type = 'alert')
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render('pages/notify', locals: { message: message, type: type }) && return }
    end
  end

  def verinice_severity(severity)
    value = severity.to_i
    if value <= 1 # green 0, blue 1
      0
    elsif value == 2 # orange
      1
    elsif value == 3 # red
      2
    elsif value >= 4 # purple 4
      3
    end
  end

  def verinice_entity
    newid = 0
    loop do
      newid = @rand.rand(100_000..999_999)
      unless @verinice_ids.include?(newid)
        @verinice_ids << newid
        break
      end
    end
    newid
  end
end
