require 'test_helper'

class ScansControllerTest < ActionDispatch::IntegrationTest
  test 'should redirect to scans_path' do
    post scans_create_url
    assert_redirected_to scans_path
  end

  test 'should not create a scan if no params given' do
    start_length = Scan.all.length
    post scans_create_url
    assert_redirected_to scans_path
    assert_not start_length < Scan.all.length
  end

  test 'should upload xml' do
    file = fixture_file_upload('files/scan.xml', 'text/xml')
    post scans_upload_url, params: { name: 'TestName',
                                     xml_file: [file] }
    assert Scan.find_by(name: 'TestName')
  end

  # should probably be in nmap_parser_test
  test 'should upload xml_nse' do
    file = fixture_file_upload('files/scan_nse.xml', 'text/xml')
    post scans_upload_url, params: { name: 'Test2Name',
                                     xml_file: [file] }
    assert Scan.find_by(name: 'Test2Name')
  end

  # That one's actually horrible to implement as a test,
  # so, for now it'll just scan localhost for basic functionality.
  test 'should launch a scan' do
    post scans_create_url, params: { command: '-sS',
                                     target: 'localhost',
                                     name: 'scantest' }
    assert Scan.find_by(name: 'scantest').present?
    assert Scan.find_by(name: 'scantest').command.include?('-sS')
  end

  test 'should launch a scan with an array of command params' do
    post scans_create_url, params: { command: ['-sS', '-p22'],
                                     target: 'localhost',
                                     name: 'scantest' }
    assert Scan.find_by(name: 'scantest').present?
    assert Scan.find_by(name: 'scantest').command.include?('-sS')
  end
end
