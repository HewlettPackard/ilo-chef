require_relative './../../spec_helper'

describe 'ilo_test::power_poweron' do
  let(:resource_name) { 'power' }
  include_context 'chef context'

  it 'power on' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_power_state).and_return('Off')
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_power_state).with('On').and_return(true)
    expect(real_chef_run).to poweron_ilo_power('power on')
  end

  it 'does not power on' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_power_state).and_return('On')
    expect(real_chef_run).to poweron_ilo_power('power on')
  end
end

describe 'ilo_test::power_poweroff' do
  let(:resource_name) { 'power' }
  include_context 'chef context'

  it 'power off' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_power_state).and_return('On')
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_power_state).with('ForceOff').and_return(true)
    expect(real_chef_run).to poweroff_ilo_power('power off')
  end

  it 'does not power off' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_power_state).and_return('Off')
    expect(real_chef_run).to poweroff_ilo_power('power off')
  end
end

describe 'ilo_test::power_resetsys' do
  let(:resource_name) { 'power' }
  include_context 'chef context'

  it 'reset sys' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_power_state).with('ForceRestart').and_return(true)
    expect(real_chef_run).to resetsys_ilo_power('reset sys')
  end
end

describe 'ilo_test::power_resetilo' do
  let(:resource_name) { 'power' }
  include_context 'chef context'

  it 'reset ilo' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:reset_ilo).and_return(true)
    expect(real_chef_run).to resetilo_ilo_power('reset ilo')
  end
end
