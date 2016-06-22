require 'ilo-sdk'
require 'chef/log'
require_relative '../libraries/ilo_helper'
require 'pry'

# General context for unit testing:
RSpec.shared_context 'shared context', a: :b do
  before :each do
    @ilo_options = { host: 'https://ilo.example.com', user: 'Administrator', password: 'secret123' }
    @client = ILO_SDK::Client.new(@ilo_options)
  end
end
