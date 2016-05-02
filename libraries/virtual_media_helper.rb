module ILO_SDK
  # Contains helper methods for indicator Virtual Media actions
  module Virtual_Media_Helper
    # Get the Virtual Media Information
    # @raise [RuntimeError] if the request failed
    # @return [String] media
    def get_virtual_media
      response = rest_get('/redfish/v1/Managers/1/VirtualMedia/')
      media = {}
      response_handler(response)['links']['Member'].each do |vm|
        response = rest_get(vm['href'])
        virtual_media = response_handler(response)
        media[virtual_media['Id']] =
        {
          'Image' => virtual_media['Image'],
          'MediaTypes' => virtual_media['MediaTypes']
        }
      end
      return media
    end

    # Set the Virtual Media Mount
    # @param [String, Symbol] id
    # @param [String, Symbol] iso_uri
    # @param [String, Symbol] boot_on_next_server_reset
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_virtual_media(id, iso_uri, boot_on_next_server_reset)
      newAction = {
        'Image' => iso_uri,
        'Oem' => {'Hp' => {'BootOnNextServerReset' => boot_on_next_server_reset}}
      }
      response = rest_patch("/redfish/v1/Managers/1/VirtualMedia/#{id}/", body: newAction)
      response_handler(response)
      true
    end
  end
end
