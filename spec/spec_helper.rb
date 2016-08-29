require 'chefspec'
require 'chefspec/berkshelf'
require 'pry'
require 'ilo-sdk'

# General context for unit testing:
RSpec.shared_context 'chef context', a: :b do
  before :each do
    ILO_SDK::ENV_VARS.each { |e| ENV[e] = nil } # Clear environment variables

    @ilo_options = { host: 'https://ilo.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(@ilo_options)
  end

  let(:real_chef_run) do
    runner = ChefSpec::ServerRunner.new(step_into: ["ilo_#{resource_name}"])
    runner.converge(described_recipe)
  end
end
