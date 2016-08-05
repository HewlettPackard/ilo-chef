require_relative './../../spec_helper'

describe 'ilo_test::account_service_create' do
  let(:resource_name) { 'account_service' }
  include_context 'chef context'

  it 'create test account' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:create_user).with('test', 'test123').and_return(true)
    expect(real_chef_run).to create_ilo_account_service('create test account')
  end

  it 'does not create test account' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2', 'test'])
    expect(real_chef_run).to create_ilo_account_service('create test account')
  end
end

describe 'ilo_test::account_service_change_password' do
  let(:resource_name) { 'account_service' }
  include_context 'chef context'

  it 'change test account password' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2', 'test'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:change_password).with('test', 'newtest123').and_return(true)
    expect(real_chef_run).to changePassword_ilo_account_service('change test account password')
  end

  it 'does not change test account password' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2'])
    expect(real_chef_run).to changePassword_ilo_account_service('change test account password')
  end
end

describe 'ilo_test::account_service_delete' do
  let(:resource_name) { 'account_service' }
  include_context 'chef context'

  it 'delete test account' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2', 'test'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:delete_user).with('test').and_return(true)
    expect(real_chef_run).to delete_ilo_account_service('delete test account')
  end

  it 'does not delete test account' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_users).and_return(['user1', 'user2'])
    expect(real_chef_run).to delete_ilo_account_service('delete test account')
  end
end
