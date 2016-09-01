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

  it 'imports the certificate' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('different_example_certificate')
    expect_any_instance_of(ILO_SDK::Client).to receive(:import_certificate).with('example_certificate').and_return(true)
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end

  it 'does not import certificate if it is unchanged' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('example_certificate')
    expect_any_instance_of(ILO_SDK::Client).to_not receive(:import_certificate)
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end
end

describe 'ilo_test::https_cert_import_from_file' do
  let(:resource_name) { 'https_cert' }
  include_context 'chef context'

  # Class to help mock file reads
  class FakeFile
    def self.read
      'example_certificate'
    end
  end

  before :each do
    # These mocks seem strange, but for some reason the duplicate and this order matters
    allow(::File).to receive(:open).with('/ilo_example_file.crt').and_return(FakeFile)
    allow(::File).to receive(:open).with(any_args).and_call_original
    allow(::File).to receive(:open).with('/ilo_example_file.crt').and_return(FakeFile)
  end

  it 'imports the certificate' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('different_example_certificate')
    expect_any_instance_of(ILO_SDK::Client).to receive(:import_certificate).with('example_certificate').and_return(true)
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end

  it 'does not import certificate if it is unchanged' do
    expect_any_instance_of(ILO_SDK::Client).to receive(:get_certificate).and_return('example_certificate')
    expect_any_instance_of(ILO_SDK::Client).to_not receive(:import_certificate)
    expect(real_chef_run).to import_ilo_https_cert('import certificate')
  end
end
