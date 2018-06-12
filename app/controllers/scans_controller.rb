# @restful_api 1.0
# Start a scan or upload an XML
class ScansController < ApplicationController
  require 'scan_job'
  require 'scan_parse_job'
  # @url /scans/create
  # @action POST
  #
  # @required [Array<String>] :target Array of targets [or String]
  # @required [String] :name name of the scan
  # @optional [String] :command space-separated String of nmap options
  def create
    if %i[target name].all? { |key| params[key].present? }
      params[:command] ||= ''
      name = params[:name]
      command = NmapCommand.new(params[:command], current_user.id, params[:target])
      scan = Scan.new(name: name, user_id: current_user.id)
      scan.command = 'Scan in progress…'
      scan.save
      ScanJob.perform_async(command, scan, current_user)
      
      respond_to do |format|
        format.html { redirect_to scans_path }
        # that's used because otherwise multipart-file-upload-js-async-things won't work as they should.
        if params[:fromGroupView].present?
          locals = { message: "Scan '#{scan.name}' created", type: 'success', close: true }
          format.js { render 'pages/notify', locals: locals }
        else
          format.js { render(js: %(window.location.href='#{scans_path}')) and return }
        end
      end
    else
      locals = { message: 'You need to specify name and target for your scan!',
                 type: 'alert' }
      respond_with_notify(locals)
    end
  end

  # @url /scans/upload
  # @action POST
  #
  # @required [String] :name name of the scan
  # @required [File] :xml_file uploaded file, XML-output of nmap -oX
  def upload
    if %i[xml_file name].all? { |key| params[key].present? }
      xmls = params[:xml_file]
      name = params[:name]
      xmls.each_with_index do |xml, index|
        FileUtils.mkdir_p(Rails.root.join('app', 'nmap', 'output'))
        destination = Rails.root.join('app', 'nmap', 'output', name + '_' + index.to_s + '.xml')
        FileUtils.move xml.path, destination

        scan = Scan.new(name: name, user_id: current_user.id)
        scan.command = 'Scan in progress…'
        scan.save

        ScanParseJob.perform_async(destination, scan, current_user)
      end
      respond_to do |format|
        format.html { redirect_to scans_path }
        format.js { render(js: %(window.location.href='#{scans_path}')) and return }
      end
    else
      locals = { message: 'You need to provide a name and a file for your upload!',
                 type: 'alert' }
      respond_with_notify(locals)
    end
  end

  def download
    # ToDo: Error: file send back in raw to client without download instructions
    # ToDo: Filename col has to be add to db model of scans and content has to be returned back with send_file
    data = "This is a test"
    file_name = "test.txt"
    send_data data, filename: file_name, type: 'text/plain'
  end

  def reload_status
    render partial: 'pages/scan_status'
  end

  def reload_finished
    render partial: 'pages/scan_finished'
  end

  private

  def respond_with_notify(locals = nil)
    # locals ||= { message: 'You need to specify a name for your scan!',
    # type: 'alert' }
    respond_to do |format|
      format.html { redirect_to scans_path }
      format.js { render 'pages/notify', locals: locals }
    end
  end
end
