require_relative './../../spec_helper'

describe 'ilo_test::user_create' do
  let(:resource_name) { 'user' }
  include_context 'chef context'

  it 'creates a user' do
    new_privileges = {
      'LoginPriv' => true,
      # 'RemoteConsolePriv' => true,
      'UserConfigPriv' => true,
      'VirtualMediaPriv' => true,
      'VirtualPowerAndResetPriv' => true,
      'iLOConfigPriv' => true
    }
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['test2'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:create_user).with('test1', 'password').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_account_privileges).with('test1', new_privileges).and_return(true)
    expect(real_chef_run).to create_ilo_user('create user')
  end

  it 'modifies a user' do
    cur_privileges = {
      'LoginPriv' => false,
      'RemoteConsolePriv' => false,
      'UserConfigPriv' => false,
      'VirtualMediaPriv' => false,
      'VirtualPowerAndResetPriv' => false,
      'iLOConfigPriv' => false
    }
    new_privileges = {
      'LoginPriv' => true,
      # 'RemoteConsolePriv' => true,
      'UserConfigPriv' => true,
      'VirtualMediaPriv' => true,
      'VirtualPowerAndResetPriv' => true,
      'iLOConfigPriv' => true
    }
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['test1', 'test2'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_account_privileges).and_return(cur_privileges)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_account_privileges).with('test1', new_privileges).and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:change_password).with('test1', 'password').and_return(true)
    expect(real_chef_run).to create_ilo_user('create user')
  end

  it 'modifies a user only if their permissions have changed' do
    cur_privileges = {
      'LoginPriv' => true,
      'RemoteConsolePriv' => true,
      'UserConfigPriv' => true,
      'VirtualMediaPriv' => true,
      'VirtualPowerAndResetPriv' => true,
      'iLOConfigPriv' => true
    }
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['test1', 'test2'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_account_privileges).and_return(cur_privileges)
    expect_any_instance_of(ILO_SDK::Client).to_not receive(:set_account_privileges)
    expect_any_instance_of(ILO_SDK::Client).to receive(:change_password).with('test1', 'password').and_return(true)
    expect(real_chef_run).to create_ilo_user('create user')
  end
end

describe 'ilo_test::user_delete' do
  let(:resource_name) { 'user' }
  include_context 'chef context'

  it 'delete user' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['test1', 'test2'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:delete_user).with('test1').and_return(true)
    expect(real_chef_run).to delete_ilo_user('delete user')
  end

  it 'does not delete user' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['test2'])
    expect(real_chef_run).to delete_ilo_user('delete user')
  end
end
