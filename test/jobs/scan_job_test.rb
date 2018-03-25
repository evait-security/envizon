require 'test_helper'
require 'sucker_punch/testing/inline'

class ScanJobTest < ActionDispatch::IntegrationTest
  test 'thing job' do
    command = NmapCommand.new('-sS', users(:john).id, ['localhost'])
    scan = Scan.new(name: 'testscan', user_id: users(:john).id)
    ScanJob.perform_async(command, scan, users(:john))
    assert File.exist? command.file_name
    assert scan.enddate.present?
    # cleanup:
    File.delete(command.file_name)
    File.delete(command.file_name.to_s.gsub('output.xml', 'exclude.txt'))
  end
end
