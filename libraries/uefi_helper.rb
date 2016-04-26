module ILO_SDK
  # Contains helper methods for UEFI actions
  module UEFI_Helper
    # Get the UEFI secure boot
    # @raise [RuntimeError] if the request failed
    # @return [String] SecureBootEnable
    def get_uefi_secure_boot
      response = rest_get('/redfish/v1/Systems/1/SecureBoot/')
      response_handler(response)['SecureBootEnable']
    end

    # Set the UEFI secure boot true or false
    # @param [String, Symbol] value
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_uefi_secure_boot(value)
      newAction = {'SecureBootEnable' => value}
      response = rest_patch('/redfish/v1/Systems/1/SecureBoot/', body: newAction)
      response_handler(response)
      true
    end
  end
end
