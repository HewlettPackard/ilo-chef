#
# Cookbook Name:: ilo
# Spec:: default
#
# Copyright (c) 2016 Hewlett Packard Enterprise

require_relative './../../spec_helper'

describe 'ilo_test::default' do

  let(:chef_run) do
    runner = ChefSpec::ServerRunner.new
    runner.converge(described_recipe)
  end

  context 'When all attributes are default, on an unspecified platform' do
    it 'converges successfully' do
      chef_run # This should not raise an error
    end
  end
end
