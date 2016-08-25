require_relative './../../spec_helper'

describe 'ilo_test::bios_revert' do
  let(:resource_name) { 'bios' }
  include_context 'chef context'

  it 'revert bios' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_baseconfig).and_return('not_default')
    expect_any_instance_of(ILO_SDK::Client).to receive(:revert_bios).and_return(true)
    expect(real_chef_run).to revert_ilo_bios('revert bios')
  end

  it 'does not revert bios' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_baseconfig).and_return('default')
    expect(real_chef_run).to revert_ilo_bios('revert bios')
  end
end

describe 'ilo_test::bios_set' do
  let(:resource_name) { 'bios' }
  include_context 'chef context'

  let(:same_settings) do
    {
      UefiShellStartup: 'Enabled',
      UefiShellStartupLocation: 'Auto',
      UefiShellStartupUrl: 'http://www.uefi.nsh',
      Dhcpv4: 'Enabled',
      Ipv4Address: '10.1.1.0',
      Ipv4Gateway: '10.1.1.11',
      Ipv4PrimaryDNS: '10.1.1.1',
      Ipv4SecondaryDNS: '10.1.1.2',
      Ipv4SubnetMask: '255.255.255.0',
      UrlBootFile: 'http://www.urlbootfile.iso',
      ServiceName: 'iLO Admin',
      ServiceEmail: 'admin@domain.com'
    }
  end

  let(:different_settings) do
    {
      UefiShellStartup: 'Disabled',
      UefiShellStartupLocation: 'Auto',
      UefiShellStartupUrl: 'http://www.uefi2.nsh',
      Dhcpv4: 'Enabled',
      Ipv4Address: '0.0.0.0',
      Ipv4Gateway: '0.0.0.0',
      Ipv4PrimaryDNS: '0.0.0.0',
      Ipv4SecondaryDNS: '0.0.0.0',
      Ipv4SubnetMask: '255.255.255.0',
      UrlBootFile: 'http://www.urlbootfile.iso',
      ServiceName: 'iLO Admin2',
      ServiceEmail: 'admin2@domain.com'
    }
  end

  it 'sets BIOS settings if there are differences' do
    current = JSON.parse(different_settings.to_json)
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_settings).and_return current
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_bios_settings).with(same_settings).and_return true
    expect(real_chef_run).to set_ilo_bios('set bios')
  end

  it 'skips the update if nothing is different' do
    current = JSON.parse(same_settings.to_json)
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_settings).and_return current
    expect_any_instance_of(ILO_SDK::Client).to_not receive(:set_bios_settings)
    expect(real_chef_run).to set_ilo_bios('set bios')
  end
end
