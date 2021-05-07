# @restful_api 1.0
# Handle all things group related
class GroupsController < ApplicationController
  # @url /groups/new
  # @action GET
  #
  # renders :new, a form for group creation
  def new
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render :new }
    end
  end

  # @url /pages/refresh
  # @action GET
  #
  # Refreshes group view
  def refresh
    respond_to do |format|
      format.html {}
      format.js { render 'groups/group_refresh', locals: { message: 'Group content has been refreshed', type: 'success', delete: '-2' } }
    end
  end

  # @url /pages/group_list
  # @action POST
  #
  # Render the sidebar in the group view
  def group_list
    load_groups_and_segments
    respond_to do |format|
      format.html {}
      format.js { render 'groups/group_list' }
    end
  end

  def index
    load_groups_and_segments
  end

  # @url /groups
  # @action POST
  #
  # Creates a new group
  #
  # @required [String] :group[:name] Name of the new group
  # @optional [Integer] :source_group ID of the source group
  # @optional [Array<Integer>] :selected_clients IDs of selected clients
  # @optional [String] :search true/false, indicator if :selected_clients are a result of a search
  # @optional [String] :move true/false, indicator if :selected_clients should be moved to the new group
  def create
    name = params[:group][:name]
    selected_clients = params[:selected_clients] if params[:selected_clients].present?
    search = ActiveModel::Type::Boolean.new.cast params[:search]
    source_group = search || params[:source_group].blank? ? nil : Group.find(params[:source_group])
    destination_group = Group.new
    destination_group.name = name.blank? ? 'Unknown' : name
    destination_group.icon = '<i class="' + params[:group][:icon] + '"></i>'
    destination_group.mod = true

    affected_group = "-2"

    render(:create_custom) && return unless destination_group.save # warn instead?
    message = "New empty group '#{destination_group.name}' created"
    respond_with_refresh(message, "-2,-2", false) && return unless selected_clients.present?

    if params[:move].present? && params[:move].casecmp('true').zero?
      if search
        tmp_array = []
        selected_clients.each { |client| Client.find(client).groups.each { |group| tmp_array << group.id}}
        affected_group = tmp_array.uniq.join(",")
      else
        affected_group = source_group.id
      end
      move_do(selected_clients, destination_group, source_group, search)
    else
      selected_clients.each { |selected| destination_group.clients << Client.find(selected) }
    end

    destination_group.save

    message = "New group '#{destination_group.name}' with #{selected_clients.length} client(s) saved."
    respond_with_refresh(message, "#{affected_group},-2", false)
  end

  # @url /groups/create_form
  # @action POST
  #
  # Renders a form for group creation, providing clients
  def create_form
    prepare_form(:create_custom)
  end

  # @url /groups/move_form
  # @action POST
  #
  # Renders a form for moving clients
  def move_form
    prepare_form(:move)
  end

  # @url /groups/move
  # @action POST
  #
  # Moves clients to a group
  #
  # @required [String] :destination_group target group ID
  # @required [Integer] :source_group ID of the source group
  # @required [Array<Integer>] :selected_clients IDs of selected clients
  # @optional [String] :search true/false, indicator if :selected_clients are a result of a search
  def move
    search = ActiveModel::Type::Boolean.new.cast params[:search]
    destination_group = Group.find(params[:destination_group])

    search ? source_group = "-2" : source_group = Group.find(params[:source_group])
    edited_groups = move_do(params[:selected_clients], destination_group, source_group, search)
    edited_groups << destination_group.id

    message = "Moved #{params[:selected_clients].length} client(s) to group '#{destination_group.name}'"
    respond_with_refresh(message, "#{edited_groups.join(',')}", false)
  end

  def move_do(selected_clients, destination_group, source_group, search)
    edited_groups = Array.new
    selected_clients.each do |selected|
      client = Client.find(selected)
      destination_group.clients << client
      next unless destination_group.save
      if search
        client.groups.each do |group|
          group.clients.delete client unless group == destination_group
          edited_groups << group.id
        end
      else
        source_group.clients.delete client
        edited_groups << source_group.id
      end
    end
    return edited_groups
  end

  # @url /groups/copy_form
  # @action POST
  #
  # Renders a form for moving clients
  def copy_form
    prepare_form(:copy)
  end

  # @url /groups/group
  # @action POST
  #
  # Render a single group html datatable
  def group
    if params[:group_id] != 'archived'
      @group = Group.find(params[:group_id])
    else
      @archived = true
    end

    respond_to do |format|
      format.html {}
      format.js { render 'groups/group' }
    end
  end

  # @url /groups/copy
  # @action POST
  #
  # Copies clients to a group
  #
  # @required [String] :destination_group target group ID
  # @required [Array<Integer>] :selected_clients IDs of selected clients
  def copy
    destination_group = Group.find(params[:destination_group])

    params[:selected_clients].each { |selected| destination_group.clients << Client.find(selected) }

    message = "Copied #{params[:selected_clients].length} client(s) to group '#{destination_group.name}'"
    respond_with_refresh(message, "#{destination_group.id},-2", false)
  end

  # @url /groups/delete_clients_form
  # @action POST
  #
  # Renders a form for deleting clients
  def delete_clients_form
    prepare_form(:delete_clients)
  end

  # Renders a form for deleting clients
  def delete_form
    if params.key?(:source_group)
      if sg = Group.find(params[:source_group])
        locals = { source_group: sg, clients: sg.clients.where(archived: false) }
        respond_root_path_js(:delete_group, locals)
      else
        respond_with_notify("Group can not be found in database.")
      end
    else
      respond_with_notify
    end
  end

  # @url /groups/delete
  # @action POST
  #
  # Delete a group
  #
  # @required [String] :source_group ID of group to delete
  def delete
    source_group = Group.find(params[:source_group])

    source_group.clients.where(archived: false).each { |client| client.destroy if client.groups.length == 1 }
    message = "Deleted group '#{source_group.name}'"
    source_group.destroy

    respond_with_refresh(message, "#{source_group.id},-2", "true")
  end

  # @url /groups/delete_clients
  # @action POST
  #
  # Deletes clients from a group (and the client itself if doesn't remain in any group or it was a search result)
  #
  # @required [String] :source_group ID of group to delete
  # @required [Array<Integer>] :selected_clients IDs of selected clients
  # @optional [String] :search true/false, indicator if :selected_clients are a result of a search
  def delete_clients
    edited_groups = Array.new
    search = ActiveModel::Type::Boolean.new.cast params[:search]

    search ? source_group = "-2" : source_group = Group.find(params[:source_group])
    selected_clients = params[:selected_clients]

    if search
      selected_clients.each do |selected|
        client = Client.find(selected)
        client.groups.each do |group|
          group.clients.delete(client)
          edited_groups << group.id
        end
        client.destroy
      end
      message = "Deleted #{selected_clients.length} client(s)."
    else
      selected_clients.each do |selected|
        client = Client.find(selected)
        source_group.clients.delete(client)
        client.destroy if client.groups.empty?
      end
      edited_groups << source_group.id
      message = "Deleted #{selected_clients.length} client(s) from group '#{source_group.name}'"
    end

    respond_with_refresh(message, "#{edited_groups.join(',')}", false)
  end

  def scan_form
    clients = Client.find(params[:clients]) if params.key?(:clients)
    if clients.blank?
      respond_with_notify
    else
      locals = { clients: clients }
      respond_root_path_js(:scan, locals)
    end
  end

  # @url /groups/export_form
  # @action POST
  #
  # Renders a form to export clients
  def export_form
    clients = Client.find(params[:clients]) if params.key?(:clients)

    if clients.nil? || clients.empty?
      respond_with_notify
    else
      locals = { clients: clients }
      respond_root_path_js(:export, locals)
    end
  end

  # @url /groups/export
  # @action POST
  #
  # Exports selected clients' IPs as a .yml - file
  #
  # @required [String] :group[:file_name] desired file_name
  # @required [Array<Integer>] :selected_clients IDs of selected clients
  def export
    file_name = (params[:group][:file_name].present? ? params[:group][:file_name] : 'exported_clients')
    clients = Client.where(id: params[:selected_clients]) if params[:selected_clients].present?
    if file_name && clients.present?
      file_name << '.txt' unless file_name =~ /.+\.(yml|yaml|txt)$/
      if file_name =~ /.+\.(yml|yaml)$/
        exceptions = %w[id created_at updated_at icon client_id]
        data = clients.left_outer_joins(:outputs, :ports).distinct.map do |c|
          ary = [c.attributes.except(*exceptions)]
          ary  << { 'ports' => c.ports.map { |p| p.attributes.except(*exceptions) } }
          ary  << { 'outputs' => c.outputs.map { |o| o.attributes.except(*exceptions) } }
        end
        send_data YAML.dump(data), filename: file_name, type: 'application/yaml'
      else
        data = clients.map(&:ip).join("\n")
        send_data data, filename: file_name, type: 'text/plain'
      end
    else
      respond_with_notify('That didn\'t work.', 'alert')
    end
  end

  private

  def load_groups_and_segments
    @all_groups = Group.all.order(mod: :asc, name: :asc).to_a
    @all_clients = Client.where(archived: false)
    all_ips = @all_clients.pluck(:ip)
    ip_t = Client.arel_table[:ip]

    # /24
    @segments_24 = []
    all_ips.group_by {|ip|ip.split(".")[0,3]}.each do |segment,clients|
      @segments_24 << [segment.join("."), clients.size, @all_clients.where(ip_t.matches("%#{segment.join(".")}%")).map{|c|c.groups.pluck(:name)}.flatten.uniq.sort]
    end

    # /16
    @segments_16 = []
    all_ips.group_by {|ip|ip.split(".")[0,2]}.each do |segment,clients|
      @segments_16 << [segment.join("."), clients.size, @all_clients.where(ip_t.matches("%#{segment.join(".")}%")).map{|c|c.groups.pluck(:name)}.flatten.uniq.sort]
    end

    # /8
    @segments_8 = []
    all_ips.group_by {|ip|ip.split(".")[0,1]}.each do |segment,clients|
      @segments_8 << [segment.join("."), clients.size, @all_clients.where(ip_t.matches("%#{segment.join(".")}%")).map{|c|c.groups.pluck(:name)}.flatten.uniq.sort]
    end
  end

  def respond_with_refresh(message, mod_gids, delete, type = 'notice')
    if current_user.settings.find_by_name('global_notify').value.include? "true"
      ActionCable.server.broadcast 'notification_channel', message: message
    end
    ActionCable.server.broadcast 'update_channel', ids: mod_gids
    @message = message
    @type = type
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'groups/group_refresh', locals: { delete: delete } }
    end
  end

  def respond_root_path_js(sym, locals)
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render sym, locals: locals }
    end
  end

  def prepare_form(sym)
    search = ActiveModel::Type::Boolean.new.cast params[:search]
    if search
      Struct.new('FakeGroup', :name, :id)
      source_group = Struct::FakeGroup.new('Custom search result', -1)
    end

    if params.key?(:clients)
      params[:clients].each do |tmpclient|
        unless Client.exists?(tmpclient)
          respond_with_notify("One of the selected clients is removed from the database.")
          return
        end
      end
      clients = Client.find(params[:clients])
      source_group ||= Group.find(params[:source_group]) unless params[:source_group].nil?
    end
    if clients.blank? || source_group.blank?
      respond_with_notify
    else
      locals = { source_group: source_group, clients: clients, search: search }
      respond_root_path_js(sym, locals)
    end
  end
end
