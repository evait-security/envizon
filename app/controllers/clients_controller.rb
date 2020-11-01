# @restful_api 1.0
# Client display and search
class ClientsController < ApplicationController#
  before_action :set_client, only: [:new_issue_form, :link_issue_form]
  before_action :set_client_and_issue, only: [:link_issue, :unlink_issue]

  def index
    require_relative '../nmap/envizon_cpe'
  end

  def search_form
  end

  # @url /clients/:id
  # @action GET
  #
  # renders client details
  def show
    unless Client.exists?(params[:id])
      respond_with_notify("The database not contains the requested client.")
    else
      respond_to do |format|
        format.html { redirect_to root_path }
          format.js { render :show, locals: { client: Client.find(params[:id]) } }
      end
    end
  end

  def archive
    clients = Client.find(params[:clients]) if params.key?(:clients)
    if clients.blank?
      respond_with_notify
    else
      archived = 0
      clients.each do |client|
        client.archived = true
        client.save!
        # client.groups.delete_all
        archived += 1
      end
      message = "Archived #{archived} client(s)"
      respond_with_refresh(message, params[:source_group],"-2", "-2")
    end
  end

  def unarchive
    clients = Client.find(params[:clients]) if params.key?(:clients)
    if clients.blank?
      respond_with_notify
    else
      archived = 0
      clients.each do |client|
        client.archived = false
        if client.groups.count = 0
          unknown = Group.where(name: 'Unknown').first_or_create(mod: false, icon: '<i class="fas fa-desktop"></i>')
          unknown << client 
        end
        client.save!
        archived += 1
      end
      message = "Unarchived #{archived} client(s)"
      respond_with_refresh(message, params[:source_group],"-2", "-2")
    end
  end

  # @url /clients/:id/new_issue_form
  # @action GET
  #
  # @required [Integer] :id
  def new_issue_form
    if @client
      @issue = Issue.new
      @issue_templates = IssueTemplate.all
      respond_to do |format|
          format.html { redirect_back root_path }
          format.js { render 'clients/new_issue' }
      end
    end
  end

  # @url /clients/:id/link_issue_form
  # @action GET
  #
  # @required [Integer] :id
  def link_issue_form
    if @client
      @issues = Report.first_or_create.all_issues
      respond_to do |format|
          format.html { redirect_back root_path }
          format.js { render 'clients/link_issue' }
      end
    end
  end

  def link_issue
    if @issue && @client
      @issue.clients << @client
      if @issue.save
        respond_with_notify("Client linked successfully","success")
      end
    end
  end

  def unlink_issue
    if @issue && @client
      @issue.clients.delete(@client)
      if @issue.save
        respond_with_notify("Client unlinked successfully","success")
      end
    end
  end


  # @url /clients/global_search
  # @action POST
  #
  # @required [Hash<_unused, Hash>] :search_name Name of the resulting search group
  # @optional [String] :group[:name] Name of the new group
  def global_search
    if params[:search_in_archived].present?
      @clients = Client.all
    else
      @clients = Client.where(archived: false)
    end

    if params.key?(:search)
      @search_name = 'Custom Search'

      or_result = nil
      params[:search].each_pair do |_not_used, param|
        next unless %i[table name value not].all? { |key| param[key].present? }

        matched = match_search_element(@clients, param)

        if param.key?(:or) && param[:or].casecmp('true').zero?
          or_result = match_or_search(or_result, matched)
        elsif or_result
          or_result = match_or_search(or_result, matched)
          @clients = match_and_search(@clients, or_result)
          or_result = nil
        else
          @clients = match_and_search(@clients, matched)
        end
      end

      if or_result
        @clients = match_and_search(@clients, or_result)
        or_result = nil
      end

      respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.js { render :search_result }
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: root_path }
        format.js { render :select_error }
      end
    end
  end

  def match_search_element(clients, input)
    table = input[:table].downcase
    name = input[:name].downcase
    value = input[:value].downcase

    unless %w[output_port output_client].include?(table)
      table_record = table.classify.constantize
      arel_table = table_record.arel_table
    end

    result = if table == 'client'
               clients.where(arel_table[name].matches("%#{value}%"))
             elsif table == 'port' && name == 'number'
               if value =~ /\A\d+\Z/
                 clients.joins(table.pluralize.to_sym)
                        .where(arel_table[name]
                        .eq(value))
               else
                 match_and_search(clients, clients.joins(:ports))
               end
             elsif table == 'output'
               output(clients, input)
             elsif %w[output_port output_client].include?(table)
               output_helper(clients, input)
             elsif table_record.column_names.include?(name)
               clients.joins(table.pluralize.to_sym)
                      .where(arel_table[name]
                      .matches("%#{value}%"))
             end
    is_not = value.present? ? input[:not].casecmp('true').zero? : !input[:not].casecmp('true').zero?

    result = clients.where.not(id: result.pluck(:id)).group(:id) if is_not && result
    result
  end

  private

  def set_client
    @client = Client.find(params[:id])
  end

  def set_client_and_issue
    @client = Client.find(params[:id])
    @issue = Issue.find(params[:issue])
  end
  
  def output(clients, input)
    value = input[:value].downcase if input[:value].present?
    output_param_name = { name: 'name', value: value, not: 'false' }

    output_param_value = { name: 'value', value: value, not: 'false' }

    if value.present?
      output_param_name[:table] = 'output_client'
      output_param_value[:table] = 'output_client'
      result_output_client = match_or_search(match_search_element(clients, output_param_name),
                                             match_search_element(clients, output_param_value))

      output_param_name[:table] = 'output_port'
      output_param_value[:table] = 'output_port'
      result_output_port = match_or_search(match_search_element(clients, output_param_name),
                                           match_search_element(clients, output_param_value))
      match_or_search(result_output_client, result_output_port)
    else
      match_or_search(match_and_search(clients, clients.joins(:outputs)),
                      match_and_search(clients, clients.joins(ports: :outputs)))
    end
  end

  def output_helper(clients, input)
    table_name = input[:table].downcase
    name = input[:name].downcase
    value = input[:value].downcase

    arel_table = Output.arel_table

    if table_name.include?('client')
      clients.joins(:outputs)
             .where(arel_table[name]
             .matches("%#{value}%"))
    else
      clients.joins(ports: :outputs)
             .where(arel_table[name]
             .matches("%#{value}%"))
    end
  end

  def match_and_search(result, input)
    return result unless input
    result.where.not(id: @clients.where.not(id: input.pluck(:id))).group(:id)
  end

  def match_or_search(result, input)
    return result if input.nil?
    result.nil? ? input : @clients.where(id: result.pluck(:id)).or(@clients.where(id: input.pluck(:id))).group(:id)
  end

  def respond_with_notify(message = 'Please make a selection', type = 'alert')
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'pages/notify', locals: { message: message, type: type, close: true } }
    end
  end

  def respond_with_refresh(message, mod_gids, delete, type = 'notice')
    if current_user.settings.find_by_name('global_notify').value.include? "true"
      ActionCable.server.broadcast 'notification_channel', message: message
    end
    ActionCable.server.broadcast 'update_channel', ids: mod_gids
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js { render 'groups/group_refresh', locals: {  message: message, delete: delete, close: true, type: type } }
    end
  end
end