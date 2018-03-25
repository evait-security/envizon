require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  test 'post groups/create_custom request works' do
    post groups_create_form_path, params: { source_group: groups(:one).id,
                                            clients: [clients(:one).id] }
    assert_redirected_to root_path
  end

  test 'post groups/create creates a group' do
    groups_count = Group.all.length
    post groups_path, params: { source_group: groups(:one).id,
                                selected_clients: [clients(:one).id],
                                group: { name: groups(:two).name,
                                         icon: groups(:two).icon } }
    assert groups_count + 1 == Group.all.length
  end

  test 'post groups/copy_form responds' do
    post groups_copy_form_path, params: { source_group: groups(:one).id,
                                          clients: [clients(:one).id,
                                                    clients(:two).id] }
    assert_redirected_to root_path
  end

  test 'post groups/copy copies client' do
    exists = groups(:two).clients.exists?(clients(:one).id)
    post groups_copy_path, params: { source_group: groups(:one).id,
                                     selected_clients: [clients(:one).id],
                                     destination_group: groups(:two).id }
    assert exists != groups(:two).clients.exists?(clients(:one).id)
  end

  test 'post groups/export_form responds' do
    post groups_export_form_path, params: { clients: [clients(:one).id,
                                                      clients(:two).id] }
    assert_redirected_to root_path
  end

  test 'post groups/move_form responds' do
    post groups_move_form_path, params: { source_group: groups(:one).id,
                                          clients: [clients(:one).id,
                                                    clients(:two).id] }
    assert_redirected_to root_path
  end

  test 'post groups/move copies client' do
    exists = groups(:two).clients.exists?(clients(:partofone).id)
    post groups_move_path, params: { source_group: groups(:one).id,
                                     selected_clients: [clients(:partofone).id],
                                     destination_group: groups(:two).id }
    assert exists != groups(:two).clients.exists?(clients(:partofone).id)
  end

  test 'post groups/move deletes client' do
    exists = groups(:one).clients.exists?(clients(:partofone).id)
    post groups_move_path, params: { source_group: groups(:one).id,
                                     selected_clients: [clients(:partofone).id],
                                     destination_group: groups(:two).id }
    assert exists != groups(:one).clients.exists?(clients(:partofone).id)
  end

  test 'post groups/delete_clients deletes client' do
    exists = groups(:one).clients.exists?(clients(:partofone).id)
    post groups_delete_clients_path, params: { source_group: groups(:one).id,
                                               selected_clients: [clients(:partofone).id] }
    assert exists != groups(:one).clients.exists?(clients(:partofone).id)
    assert Client.find_by(id: clients(:partofone).id).nil?
  end

  test 'post groups/delete deletes group' do
    post groups_delete_path, params: { source_group: groups(:one).id }
    assert Group.find_by(id: groups(:one).id).nil?
  end

  test 'post groups/delete_clients responds' do
    post groups_delete_clients_form_path, params: { source_group: groups(:one).id,
                                                    clients: [clients(:partofone).id] }
    assert_redirected_to root_path
  end

  test 'create with [:move] moves' do
    exists = groups(:one).clients.exists?(clients(:partofone).id)
    post groups_path, params: { source_group: groups(:one).id,
                                selected_clients: [clients(:partofone).id],
                                move: 'true',
                                group: { name: 'newname',
                                         icon: groups(:two).icon } }
    assert exists != groups(:one).clients.exists?(clients(:partofone).id), 'client wasn\'t removed from source_group'
    assert Group.find_by(name: 'newname').clients.exists?(clients(:partofone).id)
  end
end
