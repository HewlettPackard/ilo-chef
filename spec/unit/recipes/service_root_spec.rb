require_relative './../../spec_helper'

describe 'ilo_test::service_root_dump' do
  let(:resource_name) { 'service_root' }
  include_context 'chef context'

  it 'dump schema and registry' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_schema).with('Account').and_return([
      {
        "title" => "AccountService.1.0.0",
        "description" => "This is the schema definition for the Account service."
      }
    ])
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_registry).with('Base').and_return([
      {
        "Name" => "Base Message Registry",
        "Description" => "This registry contains the basic API response messages for the HP RESTful API."
      }
    ])
    expect(real_chef_run).to dump_ilo_service_root('dump schema and registry')
  end
end
