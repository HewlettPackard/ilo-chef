module ILO_SDK
  # Contains helper methods for indicator LED actions
  module Indicator_LED_Helper
    # Get the UID indicator LED state
    # @raise [RuntimeError] if the request failed
    # @return [String] state
    def get_indicator_led
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['IndicatorLED']
    end

    # Set the UID indicator LED
    # @param [String, Symbol] State
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_indicator_led(state)
      newAction = { 'IndicatorLED' => state }
      response = rest_patch('/redfish/v1/Systems/1/', body: newAction)
      response_handler(response)
      true
    end
  end
end
