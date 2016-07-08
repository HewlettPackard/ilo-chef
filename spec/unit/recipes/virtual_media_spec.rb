require_relative './../../spec_helper'

describe 'ilo_test::virtual_media_insert' do
  let(:resource_name) { 'virtual_media' }
  include_context 'chef context'

  it 'insert virtual media' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_virtual_media).and_return(
      0 => {
        'Image' => '',
        'MediaTypes' => ['CD', 'DVD']
      },
      1 => {
        'Image' => 'http://2.2.2.2:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['NotCD', 'NotDVD']
      }
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:virtual_media_inserted?).with(0).and_return(false)
    expect_any_instance_of(ILO_SDK::Client).to receive(:insert_virtual_media).with(0, 'http://1.1.1.1:5000/ubuntu-15.04-desktop-amd64.iso')
    expect(real_chef_run).to insert_ilo_virtual_media('insert virtual media')
  end

  it 'does not insert virtual media' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_virtual_media).and_return(
      0 => {
        'Image' => 'http://1.1.1.1:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['CD', 'DVD']
      },
      1 => {
        'Image' => 'http://2.2.2.2:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['NotCD', 'NotDVD']
      }
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:virtual_media_inserted?).with(0).and_return(true)
    expect(real_chef_run).to insert_ilo_virtual_media('insert virtual media')
  end
end

describe 'ilo_test::virtual_media_eject' do
  let(:resource_name) { 'virtual_media' }
  include_context 'chef context'

  it 'eject virtual media' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_virtual_media).and_return(
      0 => {
        'Image' => 'http://1.1.1.1:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['CD', 'DVD']
      },
      1 => {
        'Image' => 'http://2.2.2.2:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['NotCD', 'NotDVD']
      }
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:virtual_media_inserted?).with(0).and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:eject_virtual_media).with(0).and_return(true)
    expect(real_chef_run).to eject_ilo_virtual_media('eject virtual media')
  end

  it 'does not eject virtual media' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_virtual_media).and_return(
      0 => {
        'Image' => '',
        'MediaTypes' => ['CD', 'DVD']
      },
      1 => {
        'Image' => 'http://2.2.2.2:5000/ubuntu-15.04-desktop-amd64.iso',
        'MediaTypes' => ['NotCD', 'NotDVD']
      }
    )
    expect_any_instance_of(ILO_SDK::Client).to receive(:virtual_media_inserted?).with(0).and_return(false)
    expect(real_chef_run).to eject_ilo_virtual_media('eject virtual media')
  end
end
