require_relative './../../spec_helper'

describe 'ilo_test::computer_system_set' do
  let(:resource_name) { 'computer_system' }
  include_context 'chef context'

  it 'set asset tag and indicator led' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_asset_tag).and_return('HP002')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_indicator_led).and_return('On')
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_asset_tag).with('HP001').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_indicator_led).with('Off').and_return(true)
    expect(real_chef_run).to set_ilo_computer_system('set asset tag and indicator led')
  end

  it 'do not set asset tag and indicator led' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_asset_tag).and_return('HP001')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_indicator_led).and_return('Off')
    expect(real_chef_run).to set_ilo_computer_system('set asset tag and indicator led')
  end
end
