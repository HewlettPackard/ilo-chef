require_relative './../../spec_helper'

describe 'ilo_test::boot_settings_revert' do
  let(:resource_name) { 'boot_settings' }
  include_context 'chef context'

  it 'revert boot settings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_boot_baseconfig).and_return('not_default')
    expect_any_instance_of(ILO_SDK::Client).to receive(:revert_boot).and_return(true)
    expect(real_chef_run).to revert_ilo_boot_settings('revert boot settings')
  end

  it 'does not revert boot settings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_boot_baseconfig).and_return('default')
    expect(real_chef_run).to revert_ilo_boot_settings('revert boot settings')
  end
end

describe 'ilo_test::boot_settings_set' do
  let(:resource_name) { 'boot_settings' }
  include_context 'chef context'

  it 'set boot settings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_boot_order).and_return(
      [
        'Generic.USB.1.1',
        'FD.Virtual.1.1',
        'HD.Emb.1.1',
        'HD.Emb.1.2',
        'NIC.LOM.1.1.IPv4',
        'NIC.LOM.1.1.IPv6'
      ]
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_temporary_boot_order).and_return('Auto')
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_boot_order).with(
      [
        'FD.Virtual.1.1',
        'Generic.USB.1.1',
        'HD.Emb.1.1',
        'HD.Emb.1.2',
        'NIC.LOM.1.1.IPv4',
        'NIC.LOM.1.1.IPv6'
      ]
    ).and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_temporary_boot_order).with('None').and_return(true)
    expect(real_chef_run).to set_ilo_boot_settings('set boot settings')
  end

  it 'does not set boot settings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_boot_order).and_return(
      [
        'FD.Virtual.1.1',
        'Generic.USB.1.1',
        'HD.Emb.1.1',
        'HD.Emb.1.2',
        'NIC.LOM.1.1.IPv4',
        'NIC.LOM.1.1.IPv6'
      ]
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_temporary_boot_order).and_return('None')
    expect(real_chef_run).to set_ilo_boot_settings('set boot settings')
  end
end

describe 'ilo_test::boot_settings_dump' do
  let(:resource_name) { 'boot_settings' }
  include_context 'chef context'

  it 'dump boot settings' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_boot_order).and_return(
      [
        'FD.Virtual.1.1',
        'Generic.USB.1.1',
        'HD.Emb.1.1',
        'HD.Emb.1.2',
        'NIC.LOM.1.1.IPv4',
        'NIC.LOM.1.1.IPv6'
      ]
    )
    expect(real_chef_run).to dump_ilo_boot_settings('dump boot settings')
  end
end
