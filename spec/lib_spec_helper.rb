require 'chefspec' # TODO: Remove
require_relative '../libraries/ilo_helper'
require 'pry'

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    options = { host: 'ilo.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(options)
  end
end
