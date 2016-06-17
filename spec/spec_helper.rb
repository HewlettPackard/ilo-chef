require 'chefspec'
require 'chefspec/berkshelf'
require 'pry'
require_relative 'support/fake_response'

# General context for unit testing:
RSpec.shared_context 'chef context', a: :b do
  before :each do
    @ilo_options = { host: 'https://ilo.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(@ilo_options)
    #allow_any_instance_of(Net::HTTP).to receive(:request).and_raise("Please mock API Request")
  end

  let(:real_chef_run) do
    runner = ChefSpec::ServerRunner.new(step_into: ["ilo_#{resource_name}"])
    runner.converge(described_recipe)
  end
end
