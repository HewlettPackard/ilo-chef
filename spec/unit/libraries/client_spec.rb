require_relative './../../lib_spec_helper'

RSpec.describe ILO_SDK::Client do

  let(:valid_options) do
    {
      host: 'ilo.example.com',
      user: 'Administrator',
      password: 'secret123'
    }
  end

  describe '#initialize' do
    it 'creates a client with valid credentials' do
      client = described_class.new(valid_options)
      expect(client.host).to eq(valid_options[:host])
      expect(client.user).to eq(valid_options[:user])
      expect(client.password).to eq(valid_options[:password])
      expect(client.ssl_enabled).to eq(true)
      expect(client.logger.class).to eq(Logger)
      expect(client.log_level).to eq(:info)
    end

    it 'sets the user to "Administrator" by default' do
      options = { host: valid_options[:host], password: valid_options[:password] }
      client = nil
      expect { client = described_class.new(options) }.to output(/User option not set. Using default/).to_stdout_from_any_process
      expect(client.user).to eq('Administrator')
    end

    it 'allows ssl_enabled to be set' do
      client = described_class.new(valid_options.merge(ssl_enabled: false))
      expect(client.ssl_enabled).to eq(false)
    end

    it 'requires the host to be set' do
      options = { user: valid_options[:user], password: valid_options[:password] }
      expect { described_class.new(options) }.to raise_error(/Must set the host option/)
    end

    it 'requires the password to be set' do
      options = { user: valid_options[:user], host: valid_options[:host] }
      expect { described_class.new(options) }.to raise_error(/Must set the password option/)
    end
  end
end
