require_relative './../../spec_helper'

describe 'ilo_test::snmp_service_configure' do
  let(:resource_name) { 'snmp_service' }
  include_context 'chef context'

  it 'configure SNMP service' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_snmp_mode).and_return('Agentless')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_snmp_alerts_enabled).and_return(false)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_snmp).with('Passthru', true)
    expect(real_chef_run).to configure_ilo_snmp_service('configure SNMP service')
  end

  it 'does not configure SNMP service' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_snmp_mode).and_return('Passthru')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_snmp_alerts_enabled).and_return(true)
    expect(real_chef_run).to configure_ilo_snmp_service('configure SNMP service')
  end
end
