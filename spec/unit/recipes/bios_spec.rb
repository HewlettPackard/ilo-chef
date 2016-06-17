require_relative './../../spec_helper'

describe 'ilo_test::bios_revert' do
  let(:resource_name) { 'bios' }
  include_context 'chef context'

  it 'revert bios' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_baseconfig).and_return('not_default')
    expect_any_instance_of(ILO_SDK::Client).to receive(:revert_bios).and_return(true)
    expect(real_chef_run).to revert_ilo_bios('revert bios')
  end
end

describe 'ilo_test::bios_set' do
  let(:resource_name) { 'bios' }
  include_context 'chef context'

  it 'set bios' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_uefi_shell_startup).and_return({
      'UefiShellStartup' => 'Disabled',
      'UefiShellStartupLocation' => '',
      'UefiShellStartupUrl' => ''
    })
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_dhcp).and_return({
      'Dhcpv4' => 'Disabled',
      'Ipv4Address' => '0.0.0.0',
      'Ipv4Gateway' => '0.0.0.0',
      'Ipv4PrimaryDNS' => '0.0.0.0',
      'Ipv4SecondaryDNS' => '0.0.0.0',
      'Ipv4SubnetMask' => '0.0.0.0'
    })
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_url_boot_file).and_return('http://wwww.fake.iso')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_bios_service).and_return({
      'ServiceName' => 'name',
      'ServiceEmail' => 'email@email.com'
    })
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_uefi_shell_startup).with('Enabled', 'NetworkLocation', 'http://www.test.nsh').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_bios_dhcp).with('Enabled').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_url_boot_file).with('http://www.urlbootfiletest.iso').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_bios_service).with('bik', 'bik.bajwa@hpe.com')
    expect(real_chef_run).to set_ilo_bios('set bios')
  end
end
