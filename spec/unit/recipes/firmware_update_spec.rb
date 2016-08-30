require_relative './../../spec_helper'

describe 'ilo_test::firmware_update_upgrade' do
  let(:resource_name) { 'firmware_update' }
  include_context 'chef context'

  it 'upgrade firmware' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_fw_version).and_return('2.50 pass 54 Jun 20 2016')
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_fw_upgrade).with('www.firmwareURI.com').and_return(true)
    expect(real_chef_run).to upgrade_ilo_firmware_update('upgrade firmware')
  end

  it 'does not upgrade firmware' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_fw_version).and_return('2.51 pass 54 Jun 20 2016')
    expect(real_chef_run).to upgrade_ilo_firmware_update('upgrade firmware')
  end
end

describe 'ilo_test::firmware_update_upgrade_string' do
  let(:resource_name) { 'firmware_update' }
  include_context 'chef context'

  it 'accepts strings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_fw_version).and_return('2.51 pass 54 Jun 20 2016')
    expect(real_chef_run).to upgrade_ilo_firmware_update('upgrade firmware')
  end
end
