require_relative './../../spec_helper'

describe 'ilo_test::computer_details_dump' do
  let(:resource_name) { 'computer_details' }
  include_context 'chef context'

  let(:details) do
    {
      'GeneralDetails' => {
        'manufacturer' => '',
        'model' => '',
        'AssetTag' => '',
        'bios_version' => '',
        'memory' => '',
        'processors' => ''
      },
      'NetworkAdapters' => [
        {
          'Name' => '',
          'StructuredName' => '',
          'PartNumber' => '',
          'State' => '',
          'Health' => '',
          'PhysicalPorts' => [
            {
              'Name' => '',
              'StructuredName' => '',
              'MacAddress' => '',
              'State' => ''
            }
          ]
        }
      ],
      'HPSmartStorage' => {
        'Health' => '',
        'ArrayControllers' => [
          'Model' => '',
          'SerialNumber' => '',
          'State' => '',
          'Health' => '',
          'Location' => '',
          'FirmWareVersion' => '',
          'LogicalDrives' => [
            {
              'Size' => '',
              'Raid' => '',
              'Status' => '',
              'Health' => '',
              'DataDrives' => [
                {
                  'Model' => '',
                  'Name' => '',
                  'RotationalSpeedRpm' => '',
                  'SerialNumber' => '',
                  'State' => '',
                  'Health' => '',
                  'CapacityMiB' => '',
                  'CurrentTemperatureCelsius' => ''
                }
              ]
            }
          ],
          'Enclosures' => [
            {
              'Model' => '',
              'SerialNumber' => '',
              'DriveBayCount' => '',
              'State' => '',
              'Health' => '',
              'Location' => '',
              'FirmwareVersion' => ''
            }
          ]
        ]
      }
    }
  end

  it 'dump computer details' do
    allow(Chef::Log).to receive(:error).with(/Failed to load data bag item/).and_return true
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_computer_details).and_return(details)
    expect(real_chef_run).to dump_ilo_computer_details('dump computer details')
  end
end
