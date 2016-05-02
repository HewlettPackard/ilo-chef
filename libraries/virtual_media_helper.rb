module ILO_SDK
  # Contains helper methods for indicator Virtual Media actions
  module Virtual_Media_Helper
    # Get the UID indicator LED state
    # @raise [RuntimeError] if the request failed
    # @return [String] state
    #def get_indicator_led
    #  response = rest_get('/redfish/v1/Systems/1/')
    #  response_handler(response)['IndicatorLED']
    #end

    # Set the UID indicator LED
    # @param [String, Symbol] State
    # @raise [RuntimeError] if the request failed
    # @return true
    #def set_indicator_led(state)
    #  newAction = { 'IndicatorLED' => state }
    #  response = rest_patch('/redfish/v1/Systems/1/', body: newAction)
    #  response_handler(response)
    #  true
    #end

    #def mount_virtual_media(machine, iso_uri, boot_on_next_server_reset)
    #  rest_api(:get, '/redfish/v1/Managers/1/VirtualMedia/', machine)["links"]["Member"].each do |vm|
    #    virtual_media = rest_api(:get,vm["href"],machine)
    #    next if !(virtual_media["MediaTypes"].include?("CD") || virtual_media["MediaTypes"].include?("DVD"))
    #    mount = {'Image' =>  iso_uri}
    #    mount['Oem'] = {'Hp' =>  {'BootOnNextServerReset' =>  boot_on_next_server_reset}}
    #    newAction = mount
    #    options = {'body' => newAction}
    #    rest_api(:patch,vm["href"],machine,options)
    #  end
    #end

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
