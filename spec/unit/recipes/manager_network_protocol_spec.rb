require_relative './../../spec_helper'

describe 'ilo_test::manager_network_protocol_set' do
  let(:resource_name) { 'manager_network_protocol' }
  include_context 'chef context'

  it 'set timeout' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_timeout).and_return(30)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_timeout).with(60).and_return(true)
    expect(real_chef_run).to set_ilo_manager_network_protocol('set timeout')
  end

  it 'do not set timeout' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_timeout).and_return(60)
    expect(real_chef_run).to set_ilo_manager_network_protocol('set timeout')
  end
end
