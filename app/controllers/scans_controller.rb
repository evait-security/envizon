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
      args = {
        'scan_name' => params[:name],
        'user_id'   => current_user.id,
        'command'   => params[:command],
        'target'    => params[:target]
      }
      ScanWorker.perform_async(args)

      respond_to do |format|
        format.html { redirect_to scans_path }
        # that's used because otherwise multipart-file-upload-js-async-things won't work as they should.
        if params[:fromGroupView].present?
          locals = { message: "Scan '#{args['scan_name']}' created", type: 'success', close: true }
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

        ScanParseWorker.perform_async(destination, scan, current_user)
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
    return unless params[:id].present?
    file = Scan.find(params[:id]).file
    filename = File.basename(file)
    send_file file, type: 'text/xml', filename: filename, disposition: 'attachment'
  end

  def reload_status
    respond_to do |format|
      format.js { render 'pages/reload_status' }
    end
  end

  def reload_finished
    respond_to do |format|
      format.js { render 'pages/reload_finished' }
    end
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
