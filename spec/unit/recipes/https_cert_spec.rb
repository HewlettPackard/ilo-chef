require_relative './../../spec_helper'

describe 'ilo_test::https_cert_generate_csr' do
  let(:resource_name) { 'https_cert' }
  include_context 'chef context'

  it 'generate csr' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:generate_csr)
      .with('US', 'Texas', 'Houston', 'Example Company', 'Example', 'ILO.americas.example.net').and_return(true)
    expect(real_chef_run).to generate_csr_ilo_https_cert('generate csr')
  end
end

describe 'ilo_test::https_cert_dump_csr' do
  let(:resource_name) { 'https_cert' }
  include_context 'chef context'

  it 'dump csr' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_csr).and_return('Fake_CSR')
    expect(real_chef_run).to dump_csr_ilo_https_cert('dump csr')
  end
end

describe 'ilo_test::https_cert_import' do
  let(:resource_name) { 'https_cert' }
  include_context 'chef context'

  before :each do
    expect_any_instance_of(Kernel).to receive(:warn).with(/Both certificate and file_path provided/)
  end

  it 'import certificate' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('different_example_certificate')
    expect_any_instance_of(ILO_SDK::Client).to receive(:import_certificate).with('example_certificate').and_return(true)
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end

  it 'do not import certificate' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('example_certificate')
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end
end
