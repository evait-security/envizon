class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         authentication_keys: [:username]

  has_many :scans, dependent: :destroy
  has_many :settings, dependent: :destroy

  after_create do
    parallel_scans = Setting.where(user_id: id, name: 'parallel_scans').first_or_create
    parallel_scans.assign_attributes(user_id: id, name: 'parallel_scans', value: '1')
    parallel_scans.save

    exclude_hosts = Setting.where(user_id: id, name: 'exclude_hosts').first_or_create
    exclude_hosts.assign_attributes(user_id: id, name: 'exclude_hosts', value: '')
    exclude_hosts.save

    max_host = Setting.where(user_id: id, name: 'max_host_per_scan').first_or_create
    max_host.assign_attributes(user_id: id, name: 'max_host_per_scan', value: '25')
    max_host.save

    notify_scan_status = Setting.where(user_id: id, name: 'global_notify').first_or_create
    notify_scan_status.assign_attributes(user_id: id, name: 'global_notify', value: 'true')
    notify_scan_status.save
  end

  def email_required?
    false
  end

  def email_changed?
    false
  end
end
