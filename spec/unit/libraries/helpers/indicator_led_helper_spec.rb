require_relative './../../../lib_spec_helper'

RSpec.describe ILO_SDK::Client do
  include_context 'shared context'

  describe '#get_indicator_led' do
    it 'makes a GET rest call' do
      fake_response = FakeResponse.new('IndicatorLED' => 'Off')
      expect(@client).to receive(:rest_get).with('/redfish/v1/Systems/1/').and_return(fake_response)
      state = @client.get_indicator_led
      expect(state).to eq('Off')
    end
  end
  
  describe '#set_indicator_led' do
    it 'makes a PATCH rest call' do
      options = { 'IndicatorLED' => :Lit }
      expect(@client).to receive(:rest_patch).with('/redfish/v1/Systems/1/', body: options).and_return(FakeResponse.new)
      ret_val = @client.set_indicator_led(:Lit)
      expect(ret_val).to eq(true)
    end
  end
end
