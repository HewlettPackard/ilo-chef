require_relative './../../spec_helper'

describe 'ilo_test::log_entry_clear' do
  let(:resource_name) { 'log_entry' }
  include_context 'chef context'

  it 'clear log entries' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:logs_empty?).with('IEL').and_return(false)
    expect_any_instance_of(ILO_SDK::Client).to receive(:clear_logs).with('IEL').and_return(true)
    expect(real_chef_run).to clear_ilo_log_entry('clear log entries')
  end

  it 'does not clear log entries' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:logs_empty?).with('IEL').and_return(true)
    expect(real_chef_run).to clear_ilo_log_entry('clear log entries')
  end
end

describe 'ilo_test::log_entry_dump' do
  let(:resource_name) { 'log_entry' }
  include_context 'chef context'

  it 'dump log entries' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_logs).with('OK', 24, 'IEL').and_return([''])
    expect(real_chef_run).to dump_ilo_log_entry('dump log entries')
  end
end
