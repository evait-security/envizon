require 'rake'
require 'fileutils'
require 'json'

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
       export_db import_db saved_scan_name
       export_issue_templates
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

  def export_db(_param)
    app = Rake.application
    app.init
    app.add_import "#{Gem::Specification.find_by_name('yaml_db').gem_dir}/lib/tasks/yaml_db_tasks.rake"
    app.load_rakefile

    ENV['exclude'] = 'users,ar_internal_metadata'
    app['db:data:dump'].invoke
    app['db:data:dump'].reenable
    file_name = 'data.yml'
    pg_dump_name = 'envizon.db.tar'
    pg_dump_file = Rails.root.join('db', pg_dump_name)

    db_conf = Rails.configuration.database_configuration[Rails.env]
    db_connection_string = "--dbname=postgresql://#{db_conf['username']}:#{db_conf['password']}@:5432/#{db_conf['database']}?host=#{db_conf['host']}"
    pg_cmd = ['pg_dump',
              '-c', '-b',
              '-F', 'tar',
              '-f', pg_dump_file,
              db_connection_string]
    `#{pg_cmd.join(' ')}`

    # zip storage folder
    output_filename = 'data.zip'
    active_storage_filename = 'storage'
    FileUtils.mkdir_p(Rails.root.join(active_storage_filename)) unless Dir.exist?('storage')
    output_file = Tempfile.new(output_filename)

    # fix error by open tempfile
    Zip::OutputStream.open(output_file) { |zos| }
    # zip the files
    ::Zip::File.open(output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries (Dir.entries(Rails.root.join(active_storage_filename)) - %w[. ..]),
                    active_storage_filename, zipfile, Rails.root
      zipfile.add(file_name, Rails.root.join('db', file_name))
      zipfile.add(pg_dump_name, pg_dump_file)
    end

    FileUtils.remove_file(pg_dump_file, force: true)
    send_file output_file, filename: output_filename, type: 'application/zip' and return
  end

  def export_issue_templates(_param)
    # Testing
    # values = [{ title: 'nothing', description: 'nothing', rating: 'nothing', recommendation: 'nothing', severity: 1 }]
    # IssueTemplate.import values, validate: true
    tempfile = File.new(Rails.root.join('tmp') + 'issue_template.json', 'w')
    # ugly output with ids
    # tempfile.write IssueTemplate.all.to_json
    # nice output without ids
    tempfile.write JSON.pretty_generate(IssueTemplate.all.map { |md| md.serializable_hash.except('id') })
    tempfile.rewind
    send_file tempfile, filename: 'issue_templates.json', type: 'application/json'
    nil
  end

  def import_issue_templates(file)
    # Tests for import exported files
    # alltemplates = JSON.parse(IssueTemplate.all.to_json)
    # IssueTemplate.all.delelete_all
    # IssueTemplate.import JSON.parse(IssueTemplate.all.to_json), validate: true
    begin
      json_import = File.read(file.first.tempfile.path)
      IssueTemplate.all.delete_all
      IssueTemplate.import JSON.parse(json_import), validate: true
      { message: "Issue templates successfully imported", type: 'success' }
    rescue StandardError
      { message: "The import was not successful. The data may not be in the right format", type: 'alert' }
    end
  end

  def import_db(file)
    extract_dir = Dir.mktmpdir
    Zip::ZipFile.open(file.first.tempfile) do |zip_file|
      zip_file.each do |f|
        f_path = File.join(extract_dir, f.name)
        FileUtils.mkdir_p(File.dirname(f_path))
        zip_file.extract(f, f_path) unless File.exist?(f_path)
      end
    end
    unziped_storage = File.join(extract_dir, 'storage')
    # out_storage = Rails.root.join('storage')
    unziped_data_sql = File.join(extract_dir, 'envizon.db.tar')
    out_data_sql = Rails.root.join('db', 'envizon.db.tar')
    # unziped_data_yml = File.join(extract_dir, 'data.yml')
    # out_data_yml = Rails.root.join('db', 'data.yml')

    FileUtils.rm_rf(Rails.root.join('storage'))
    # FileUtils.mv(unziped_storage, Rails.root) # not work because storage folder can not be deleted
    Dir.children(unziped_storage).each do |f|
      FileUtils.mv(File.join(unziped_storage , f), Rails.root.join('storage'))
    end

    app = Rake.application
    app.init
    app.add_import "#{Gem::Specification.find_by_name('yaml_db').gem_dir}/lib/tasks/yaml_db_tasks.rake"
    app.load_rakefile

    FileUtils.cp(Pathname.new(unziped_data_sql), out_data_sql)
    # app['db:data:load'].invoke
    # app['db:data:load'].reenable
    { message: 'Import complete, now restart your Docker containers', type: 'success' }
  end

  def saved_scan_name(scan_name)
    if params[:saved_scan_id].present?
      scan = SavedScan.find(params[:saved_scan_id])
      if scan_name.empty? || params[:saved_scan_param].empty?
        message = "Removed saved scan '#{scan_name}'"
        scan.delete
      else
        scan.assign_attributes(name: scan_name, parameter: params[:saved_scan_param])
        scan.save
        message = "Modified saved scan '#{scan_name}'"
      end
    else
      SavedScan.create(name: scan_name, parameter: params[:saved_scan_param])
      message = "Created saved scan '#{scan_name}'"
    end
    { message: message, type: 'success',
      partial_render: 'pages/settings_scans',
      partial_render_id: 'settings_scans_list' }
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

  def respond_with_notify(locals)
    return unless locals

    respond_to do |format|
      format.html { redirect_back fallback_location: root_path }
      format.js { render 'pages/notify', locals: locals }
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
