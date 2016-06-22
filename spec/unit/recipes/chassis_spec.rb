require_relative './../../spec_helper'

describe 'ilo_test::chassis_dump' do
  let(:resource_name) { 'chassis' }
  include_context 'chef context'

  it 'dump chassis metrics' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_power_metrics).and_return({
        'ilo.example.com' => {
          'PowerCapacityWatts' => '',
          'PowerConsumedWatts' => '',
          'PowerSupples' => {
            'LineInputVoltage' => '',
            'LineInputVoltageType' => '',
            'PowerCapacityWatts' => '',
            'PowerSupplyType' => '',
            'Health' => '',
            'State' => ''
          }
        }
    })
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_thermal_metrics).and_return({
        'ilo.example.com' => {
          'PhysicalContext' => '',
          'Name' => '',
          'CurrentReading' => '',
          'CriticalThreshold' => '',
          'Health' => '',
          'State' => ''
        }
    })
    expect(real_chef_run).to dump_ilo_chassis('dump chassis metrics')
  end
end
