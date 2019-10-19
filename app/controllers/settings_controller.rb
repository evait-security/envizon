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
    %w[parallel_scans global_notify hosts export_db import_db saved_scan_name export_issue_templates import_issue_templates].each do |param|
      param_sym = param.to_sym
      next unless params[param_sym]
      respond_with_notify(send(param_sym, params[param_sym])) && return
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

  def export_db(_param)
    app = Rake.application
    app.init
    app.add_import "#{Gem::Specification.find_by_name('yaml_db').gem_dir}/lib/tasks/yaml_db_tasks.rake"
    app.load_rakefile

    ENV['exclude'] = 'users,ar_internal_metadata'
    app['db:data:dump'].invoke
    app['db:data:dump'].reenable
    file_name = 'data.yml'
    send_file Rails.root.join('db', file_name), filename: file_name, type: 'application/yaml'
    nil
  end

  def export_issue_templates(param)
    # Testing
    # values = [{ title: 'nothing', description: 'nothing', rating: 'nothing', recommendation: 'nothing', severity: 1 }]
    # IssueTemplate.import values, validate: true
    tempfile = File.new(Rails.root.join('tmp') + 'issue_template.json', 'w')
    # ugly output with ids
    # tempfile.write IssueTemplate.all.to_json
    # nice output without ids
    tempfile.write JSON.pretty_generate(IssueTemplate.all.map {|md| md.serializable_hash.except('id')})
    tempfile.rewind
    send_file tempfile, filename: "issue_templates.json", type: 'application/json'
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
    rescue
      { message: "The import was not successfull. The data may not in the right format", type: 'alert' }
    end


  end


  def import_db(file)
    app = Rake.application
    app.init
    app.add_import "#{Gem::Specification.find_by_name('yaml_db').gem_dir}/lib/tasks/yaml_db_tasks.rake"
    app.load_rakefile

    out = Rails.root.join('db', 'data.yml')
    FileUtils.cp(file.first.tempfile.path, out)
    app['db:data:load'].invoke
    app['db:data:load'].reenable
    { message: 'Database successfully imported', type: 'success' }
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

  def global_notify(_global_notify)
    setting = current_user.settings.where(name: 'global_notify').first_or_create
    if params[:global_notify_setting].present?
      setting.value = "true"
    else
      setting.value = "false"
    end
    setting.save
    { message: 'Notication settings updated', type: 'success' }
  end

  def respond_with_notify(locals)
    return unless locals
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'pages/notify', locals: locals }
    end
  end
end
