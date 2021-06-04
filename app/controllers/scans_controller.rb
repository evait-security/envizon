# @restful_api 1.0
# Start a scan or upload an XML
class ScansController < ApplicationController

  def new
  end

  # @url /scans/create
  # @action POST
  #
  # @required [Array<String>] :target Array of targets [or String]
  # @required [String] :name name of the scan
  # @optional [String] :command space-separated String of nmap options
  def create
    params[:scan][:target] = Client.where(archived: false).pluck(:ip).join(' ') if params[:all_clients].present?

    if %i[target name].all? { |key| params[:scan][key].present? }
      params[:scan][:command] ||= ''
      args = {
        'scan_name' => params[:scan][:name],
        'user_id' => current_user.id,
        'command' => params[:scan][:command],
        'target' => params[:scan][:target]
      }
      command = NmapCommand.new(args['command'], current_user.id, args['target'])
      scan = Scan.new(name: args['scan_name'], user_id: args['user_id'])
      scan.command = 'Scan in progress…'
      scan.save
      command.run_worker(scan)

      respond_to do |format|
        format.html { redirect_to new_scan_path }
        format.js {
          respond_with_notify("Scan '#{args['scan_name']}' created", 'success')
        }
      end
    else
      respond_with_notify('You need to specify name and target for your scan!', 'alert')
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
        FileUtils.mkdir_p(Rails.root.join('nmap', 'uploads'))
        destination = Rails.root.join('nmap', 'uploads', "#{name}_#{index.to_s}.xml")
        FileUtils.move xml.path, destination

        scan = Scan.new(name: name, user_id: current_user.id)
        scan.command = 'Scan in progress…'
        scan.save

        args_parse = {
          'xmlpath' => destination,
          'scan_id' => scan.id,
          'user_id' => current_user.id
        }
        ScanParseWorker.perform_async(args_parse)
      end
      respond_with_notify("Files uploaded and will be now processed")
    else
      respond_with_notify("You need to provide a name and a file for your upload!", "alert")
    end
  end

  def download
    return unless params[:id].present?

    file = Scan.find(params[:id]).file
    filename = File.basename(file)
    send_file file, type: 'text/xml', filename: filename, disposition: 'attachment'
  end
end
