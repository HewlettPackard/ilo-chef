module ILO_SDK
  # Contains helper methods for Power Management actions
  module Powermgmt_Helper
      # Get the Power State
    # @raise [RuntimeError] if the request failed
    # @return [String] state
    def get_power_state
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)["PowerState"]
    end

    # Set the Power State
    # @param [String, Symbol] State
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_power_state(state)
      newAction = {"Action" => "Reset", "ResetType" => state}
      response = rest_post('/redfish/v1/Systems/1/', body: newAction)
      response_handler(response)
      true
    end

    # Reset the iLO
    # @raise [RuntimeError] if the request failed
    # @return true
    def reset_ilo
      newAction = {"Action" => "Reset"}
      response = rest_post('/redfish/v1/Managers/1/', body: newAction)
      response_handler(response)
      true
    end
  end
end
