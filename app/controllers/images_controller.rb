class ImagesController < ApplicationController
  before_action :set_clients, only: [:scan_custom_overwrite]

  def index
    load_groups_and_segments
    @all_groups = Group.all.order(mod: :asc, name: :asc).to_a
    @images = Port.joins(:image_attachment).map { |p| p.image }.sort { |i| i.created_at }
  end

  def nuke
    Port.joins(:image_attachment).map { |p| p.image }.sort { |i| i.created_at }.each { |i| i.purge }
  end

  def scan_all
    args = { 'overwrite' => false }
    ScreenshotOperatorWorker.perform_async(args)
    respond_with_notify('Re-Scan started. Please refresh this page to get new results!', 'notice')
  end

  def scan_all_overwrite
    args = { 'overwrite' => true }
    ScreenshotOperatorWorker.perform_async(args)
    respond_with_notify('Re-Scan with overwrite started. Please refresh this page to get new results!', 'notice')
  end

  def scan_custom_overwrite
    args = { 'clients' => @clients, 'overwrite' => true }
    ScreenshotOperatorWorker.perform_async(args)
    respond_with_notify('Selected clients add no screenshot queue. Please refresh image page to view the results!',
                        'success')
  end

  private

  def load_groups_and_segments
    @all_groups = Group.all.order(mod: :asc, name: :asc).to_a
    @all_clients = Client.where(archived: false)
    all_ips = @all_clients.pluck(:ip)
    ip_t = Client.arel_table[:ip]

    # /24
    @segments_24 = []
    all_ips.group_by { |ip| ip.split('.')[0, 3] }.each do |segment, clients|
      @segments_24 << [segment.join('.'), clients.size, @all_clients.where(ip_t.matches("%#{segment.join('.')}%")).map do |c|
                                                          c.groups.pluck(:name)
                                                        end.flatten.uniq.sort]
    end

    # /16
    @segments_16 = []
    all_ips.group_by { |ip| ip.split('.')[0, 2] }.each do |segment, clients|
      @segments_16 << [segment.join('.'), clients.size, @all_clients.where(ip_t.matches("%#{segment.join('.')}%")).map do |c|
                                                          c.groups.pluck(:name)
                                                        end.flatten.uniq.sort]
    end

    # /8
    @segments_8 = []
    all_ips.group_by { |ip| ip.split('.')[0, 1] }.each do |segment, clients|
      @segments_8 << [segment.join('.'), clients.size, @all_clients.where(ip_t.matches("%#{segment.join('.')}%")).map do |c|
                                                         c.groups.pluck(:name)
                                                       end.flatten.uniq.sort]
    end
  end

  def set_clients
    @clients = []
    params[:clients].each do |client|
      @clients << Client.find_by_id(client).id
    end
  rescue StandardError => e
    respond_with_notify('Invalid client in request', 'alert')
  end
end
