require_relative './../../lib_spec_helper'

RSpec.describe 'IloHelper' do
  include_context 'shared context'

  let(:helper) do
    (Class.new { include IloHelper }).new
  end

  let(:sdk_version) do
    '>= 0.1'
  end

  describe '#load_sdk' do
    before :each do
      allow(helper).to receive(:node).and_return('ilo' => { 'ruby_sdk_version' => sdk_version })
    end

    it 'loads the specified version of the gem' do
      expect(helper).to receive(:gem).with('ilo-sdk', sdk_version)
      helper.load_sdk
    end

    it 'attempts to install the gem if it is not found' do
      expect(helper).to receive(:gem).and_raise LoadError
      expect(helper).to receive(:chef_gem).with('ilo-sdk').and_return true
      expect(helper).to receive(:require).with('ilo-sdk').and_return true
      helper.load_sdk
    end
  end

  describe '#build_client' do
    it 'requires a parameter' do
      expect { helper.build_client }.to raise_error(/wrong number of arguments/)
    end

    it 'requires a valid ilo object' do
      expect { helper.build_client(nil) }.to raise_error(/Invalid client/)
    end

    it 'accepts an ILO_SDK::Client object' do
      ilo = helper.build_client(@client)
      expect(ilo).to eq(@client)
    end

    it 'accepts a hash' do
      ilo = helper.build_client(@ilo_options)
      expect(ilo.host).to eq(@ilo_options[:host])
      expect(ilo.user).to eq(@ilo_options[:user])
      expect(ilo.password).to eq(@ilo_options[:password])
    end

    it 'defaults the log level to what Chef is using' do
      ilo = helper.build_client(@ilo_options)
      expect(ilo.log_level).to eq(Chef::Log.level)
    end

    it 'allows the log level to be overridden' do
      level = Chef::Log.level == :warn ? :info : :warn
      ilo = helper.build_client(@ilo_options.merge(log_level: level))
      expect(ilo.log_level).to eq(level)
      expect(ilo.log_level).to_not eq(Chef::Log.level)
    end
  end
end
