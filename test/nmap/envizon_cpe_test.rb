require 'test_helper'
require_relative Rails.root.join('app', 'nmap', 'envizon_cpe.rb')

class EnvizonCpeTest < ActionDispatch::IntegrationTest
  test 'should get name for linux' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:linux))
    expected_name = 'Linux'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end

  test 'should get icon for linux' do
    e_cpe = EnvizonCpe.new
    icon = e_cpe.icon(clients(:linux))
    expected_icon = '<i class="fa fa-linux"></i>'
    assert_equal(expected_icon, icon,
                 "CPE-name of Client isn't #{expected_icon} is #{icon}")
  end

  test 'should get name for windows' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:msw))
    expected_name = 'Microsoft Operating System'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end

  test 'should get icon for windows' do
    e_cpe = EnvizonCpe.new
    icon = e_cpe.icon(clients(:msw))
    expected_icon = '<i class="fa fa-windows"></i>'
    assert_equal(expected_icon, icon,
                 "CPE-name of Client isn't #{expected_icon} is #{icon}")
  end

  test 'should get name for windows 10' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:msw10))
    expected_name = 'Microsoft Windows 10'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end

  test 'should get name for iphone' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:iphone))
    expected_name = 'iOS'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end
  test 'should get name for osx' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:osx))
    expected_name = 'macOS'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end
  test 'should get name for openbsd' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.name(clients(:bsd))
    expected_name = 'OpenBSD'
    assert_equal(expected_name, name,
                 "CPE-name of Client isn't #{expected_name}, is #{name}")
  end
  test 'should get group for iphone' do
    e_cpe = EnvizonCpe.new
    name = e_cpe.group(clients(:iphone))
    expected_group = 'Apple Mobile'
    assert_equal(expected_group, name,
                 "CPE-name of Client isn't #{expected_group}, is #{name}")
  end

end
