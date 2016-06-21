require_relative './../../spec_helper'

describe 'ilo_test::secure_boot_set' do
  let(:resource_name) { 'secure_boot' }
  include_context 'chef context'

  it 'enable secure boot' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_uefi_secure_boot).and_return(false)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_uefi_secure_boot).with(true).and_return(true)
    expect(real_chef_run).to set_ilo_secure_boot('enable secure boot')
  end

  it 'does not enable secure boot' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_uefi_secure_boot).and_return(true)
    expect(real_chef_run).to set_ilo_secure_boot('enable secure boot')
  end
end
