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

    # Return whether Virtual Media is inserted
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] inserted
    def is_virtual_media_inserted?(id)
      response = rest_get('/redfish/v1/Managers/1/VirtualMedia/2/')
      response_handler(response)['Inserted']
    end

    # Insert Virtual Media
    # @param [String, Symbol] id
    # @param [String, Symbol] image
    # @return true
    def insert_virtual_media(id, image)
      newAction = {
        "Action" => "InsertVirtualMedia",
        "Target" => "/Oem/Hp",
        "Image" => "http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso"
      }
      response = rest_post("/redfish/v1/Managers/1/VirtualMedia/#{id}/", body: newAction)
      response_handler(response)
      true
    end

    # Eject Virtual Media
    # @param [String, Symbol] id
    # @return true
    def eject_virtual_media(id)
      newAction = {
        "Action" => "EjectVirtualMedia",
        "Target" => "/Oem/Hp"
      }
      response = rest_post("/redfish/v1/Managers/1/VirtualMedia/#{id}/", body: newAction)
      response_handler(response)
      true
    end
  end
end
