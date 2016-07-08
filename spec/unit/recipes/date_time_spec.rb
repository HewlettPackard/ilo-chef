require_relative './../../spec_helper'

describe 'ilo_test::date_time_set' do
  let(:resource_name) { 'date_time' }
  include_context 'chef context'

  it 'set time zone, NTP, and NTP servers' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_time_zone).and_return('Asia/Macau')
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_ntp).and_return(false)
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_ntp_servers).and_return(['0.0.0.0', '3.3.3.3'])
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_time_zone).with('Africa/Abidjan').and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_ntp).with(true).and_return(true)
    expect_any_instance_of(ILO_SDK::Client).to receive(:set_ntp_servers).with(['1.1.1.1', '2.2.2.2']).and_return(true)
    expect(real_chef_run).to set_ilo_date_time('set time zone, NTP, and NTP servers')
  end

  # it 'does not set time zone, NTP, and NTP servers' do
  #  expect_any_instance_of(ILO_SDK::Client).to receive(:get_time_zone).and_return('Africa/Abidjan')
  #  expect_any_instance_of(ILO_SDK::Client).to receive(:get_ntp).and_return(true)
  #  expect_any_instance_of(ILO_SDK::Client).to receive(:get_ntp_servers).and_return([
  #    '1.1.1.1',
  #    '2.2.2.2'
  #  ])
  #  expect(real_chef_run).to set_ilo_date_time('set time zone, NTP, and NTP servers')
  # end
end
