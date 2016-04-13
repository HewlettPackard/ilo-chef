module ILO_SDK
  # Contains helper methods for indicator LED actions
  module Timeout_Helper
    # Get the Session Timeout Minutes
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] timeout
    def get_timeout
      response = rest_get('/redfish/v1/Managers/1/NetworkService/')
      response_handler(response)["SessionTimeoutMinutes"]
    end

    # Set the Session Timeout Minutes
    # @param [Fixnum] timeout
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_timeout(timeout)
      newAction = {"SessionTimeoutMinutes" => timeout}
      response = rest_patch('/redfish/v1/Managers/1/NetworkService/', body: newAction)
      response_handler(response)
      true
    end
  end
end
