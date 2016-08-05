require_relative './../../spec_helper'

describe 'ilo_test::manager_account_set_privileges' do
  let(:resource_name) { 'manager_account' }
  include_context 'chef context'

  it 'set privileges' do
    privileges = {
      'LoginPriv' => false,
      'RemoteConsolePriv' => false,
      'UserConfigPriv' => false,
      'VirtualMediaPriv' => false,
      'VirtualPowerAndResetPriv' => false,
      'iLOConfigPriv' => false
    }
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_account_privileges).with('test').and_return(privileges)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_account_privileges).with('test', true, true, true, true, true, true).and_return(true)
    expect(real_chef_run).to set_privileges_ilo_manager_account('set privileges')
  end

  it 'does not set privileges' do
    privileges = {
      'LoginPriv' => true,
      'RemoteConsolePriv' => true,
      'UserConfigPriv' => true,
      'VirtualMediaPriv' => true,
      'VirtualPowerAndResetPriv' => true,
      'iLOConfigPriv' => true
    }
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_account_privileges).with('test').and_return(privileges)
    expect(real_chef_run).to set_privileges_ilo_manager_account('set privileges')
  end
end
