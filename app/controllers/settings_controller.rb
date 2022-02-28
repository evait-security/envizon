require 'rake'
require 'fileutils'
require 'json'
require 'uri'
require 'down'

# @restful_api 1.0
# Handle user settings
class SettingsController < ApplicationController
  def edit; end

  # @url /settings/update
  # @action POST
  #
  # Update user settings
  # @required [Params] params[:setting_to_set] Setting(s) to change
  def update
    %w[parallel_scans global_notify
       max_host_per_scan hosts
       mysql_connection methodologies_url
       import_issue_templates report_mode].each do |param|
      param_sym = param.to_sym
      next unless params[param_sym]

      respond_with_notify(send(param_sym, params[param_sym])) and return
    end
  end

  private

  def parallel_scans(parallel)
    setting = User.first.settings.find_by_name('parallel_scans')
    if parallel =~ /\A\d+\Z/
      setting.value = parallel
      setting.save
    end
    { message: "Parallel Scans settings updated to '#{parallel}'", type: 'success' }
  end

  def report_mode(report_mode)
    setting = current_user.settings.where(name: 'report_mode').first_or_create
    return unless report_mode.present?

    setting.value = report_mode
    setting.save
  end

  def import_issue_templates(_param)
    set_mysql_client

    begin
      issue_template_remote = @mysql_client.query("SELECT * FROM issue_templates")

      # dangerous things incomming
      IssueTemplate.delete_all
      # dangerous things completed

      issue_template_remote.each do |it_remote|
        IssueTemplate.create(
          :uuid => it_remote['id'],
          :title => it_remote['title'],
          :description => it_remote['description'],
          :rating => it_remote['rating'],
          :recommendation => it_remote['recommendation'],
          :severity => it_remote['severity']
        )
      end

      { message: "Issue templates successfully imported / synced", type: 'success' }
    rescue => exception
      { message: exception, type: 'alert' }
    end
  end

  def methodologies_url(methodologies_url)
    if params[:methodologies_url_setting].present?
      m_url = params[:methodologies_url_setting]
      return { message: "Invalid URL provided", type: 'alert' } unless m_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      begin
        # remove old directories
        FileUtils.rm_rf("/tmp/envizon-methodologies-dest")
        # download zip file to temp location
        tempfile = Down.download(m_url)
        extract_zip(tempfile.path, "/tmp/envizon-methodologies-dest")
        Dir.glob("/tmp/envizon-methodologies-dest/**/*.yaml").each do |f|
          temp_yml = YAML.load_file(f)
          if temp_yml
            temp_yml.deep_symbolize_keys!

          end
        end
        { message: tempfile.path, type: 'success' }
      rescue => exception
        { message: exception, type: 'alert' }
      end
    else
      { message: "No URL was given", type: 'alert' }
    end

  end

  def extract_zip(file, destination)
    FileUtils.mkdir_p(destination)

    Zip::File.open(file) do |zip_file|
      zip_file.each do |f|
        fpath = File.join(destination, f.name)
        zip_file.extract(f, fpath) unless File.exist?(fpath)
      end
    end
  end

  def hosts(hosts_given)
    setting = current_user.settings.where(name: 'exclude_hosts').first_or_create
    setting.value = YAML.dump(hosts_given)
    setting.save
    { message: "#{hosts_given.lines.count} hosts excluded", type: 'success' }
  end

  def global_notify(global_notify)
    setting = current_user.settings.where(name: 'global_notify').first_or_create
    setting.value = params[:global_notify_setting].present? ? 'true' : 'false'
    setting.save
    { message: 'Notification settings updated', type: 'success' }
  end

  def max_host_per_scan(max_host_per_scan)
    setting = current_user.settings.where(name: 'max_host_per_scan').first_or_create
    if params[:max_host_per_scan_setting].present?
      value = params[:max_host_per_scan_setting].to_i
      setting.value = value.positive? ? value.to_s : '0'
    else
      setting.value = '0'
    end
    setting.save
    { message: 'Host-Splitting settings updated', type: 'success' }
  end

  def mysql_connection(mysql_connection)
    setting = current_user.settings.where(name: 'mysql_connection').first_or_create
    if params[:mysql_connection_setting].present?
      begin
        Mysql2::Client.new(JSON.parse(params[:mysql_connection_setting]))
        setting.value = params[:mysql_connection_setting]
        setting.save
        result = { message: 'The mysql connection was successfully established and saved', type: 'success' }
      rescue => exception
        result = { message: exception.message, type: 'alert' }
      end
    else
      result = { message: 'Mysql connection string not set', type: 'alert' }
    end
    result
  end

  def set_mysql_client
    begin
      @mysql_client = Mysql2::Client.new(JSON.parse(current_user.settings.where(name: 'mysql_connection').first_or_create.value))
    rescue => exception
      respond_with_notify(exception.message, "alert")
    end
  end

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile, root_dir)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(root_dir, zipfile_path)

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path, root_dir)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path, root_dir)
    zipfile.mkdir zipfile_path
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile, root_dir
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path)
    zipfile.add(zipfile_path, disk_file_path)
  end
end
