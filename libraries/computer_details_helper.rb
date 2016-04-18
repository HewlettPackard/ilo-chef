module ILO_SDK
  # Contains helper methods for computer details actions
  module Computer_Details_Helper
    # Get all of the computer details
    # @raise [RuntimeError] if the request failed
    # @return [Hash] computer_details
    def get_computer_details
      general_computer_details = get_general_computer_details
      computer_network_details = get_computer_network_details
      array_controller_details = get_array_controller_details
      general_computer_details.merge(computer_network_details).merge(array_controller_details)
    end

    # Get the general computer details
    # @raise [RuntimeError] if the request failed
    # @return [Fixnum] general_computer_details
    def get_general_computer_details
      response = rest_get('/redfish/v1/Systems/1/')
      details = response_handler(response)
      {
        'GeneralDetails' => {
        'manufacturer' => details["Manufacturer"],
        'model' => details["Model"],
        'AssetTag' => details['AssetTag'],
        'bios_version' => details['Bios']['Current']['VersionString'],
        'memory' => details['Memory']['TotalSystemMemoryGB'].to_s + ' GB',
        'processors' => details['Processors']['Count'].to_s + ' x ' + details['Processors']['ProcessorFamily'].to_s}
      }
    end

    # Get the computer network details
    # @raise [RuntimeError] if the request failed
    # @return [Hash] computer_network_details
    def get_computer_network_details
      network_adapters = []
      response = rest_get('/redfish/v1/Systems/1/NetworkAdapters/')
      networks = response_handler(response)["links"]["Member"]
      networks.each do |network|
        response = rest_get(network["href"])
        detail = response_handler(response)
        physical_ports = []
        detail['PhysicalPorts'].each do |port|
          n = {
            'Name' => port['Name'],
            'StructuredName' => port['Oem']['Hp']['StructuredName'],
            'MacAddress' => port['MacAddress'],
            'State' => port['Status']['State']
          }
          physical_ports.push(n)
        end
        nets = {
          'Name' => detail['Name'],
          'StructuredName' => detail['StructuredName'],
          'PartNumber'  =>  detail['PartNumber'],
          'State' => detail['Status']['State'],
          'Health' => detail['Status']['Health'],
          'PhysicalPorts' => physical_ports
        }
        network_adapters.push(nets)
      end
      {
        'NetworkAdapters' => network_adapters
      }
    end

    # Get the array controller details
    # @raise [RuntimeError] if the request failed
    # @return [Hash] array_controller_details
    def get_array_controller_details
      response = rest_get('/redfish/v1/Systems/1/SmartStorage/')
      storages = response_handler(response)
      array_controllers = []
      response = rest_get(storages['links']['ArrayControllers']['href'])
      array_ctrls = response_handler(response)
      if array_ctrls['links'].has_key? 'Member'
        array_ctrls['links']['Member'].each do |array_controller|
          response = rest_get(array_controller['href'])
          controller = response_handler(response)
          storage_enclosures = []
          response = rest_get(controller['links']['StorageEnclosures']['href'])
          response_handler(response)['links']['Member'].each do |enclosure|
            response = rest_get(enclosure['href'])
            enclsr = response_handler(response)
            enc = {
              'Model' => enclsr['Model'],
              'SerialNumber' => enclsr['SerialNumber'],
              'DriveBayCount' => enclsr['DriveBayCount'],
              'State' => enclsr['Status']['State'],
              'Health' => enclsr['Status']['Health'],
              'Location' => enclsr['Location'].to_s + ' (' + enclsr['LocationFormat'].to_s + ')',
              'FirmwareVersion' => enclsr['FirmwareVersion']['Current']['VersionString']
            }
            storage_enclosures.push(enc)
          end

          logical_drives = []
          response = rest_get(controller['links']['LogicalDrives']['href'])
          response_handler(response)['links']['Member'].each do |logicaldrive|
            response = rest_get(logicaldrive['href'])
            lds = response_handler(response)
            data_drives = []
            response = rest_get(lds['links']['DataDrives']['href'])
            response_handler(response)['links']['Member'].each do |datadrives|
              response = rest_get(datadrives['href'])
              disk_drive = response_handler(response)
              dd = {
                'Model' => disk_drive['Model'],
                'Name' => disk_drive['Name'],
                'RotationalSpeedRpm' => disk_drive['RotationalSpeedRpm'],
                'SerialNumber' => disk_drive['SerialNumber'],
                'State' => disk_drive['Status']['State'],
                'Health' => disk_drive['Status']['Health'],
                'CapacityMiB' => disk_drive['CapacityMiB'],
                'CurrentTemperatureCelsius' => disk_drive['CurrentTemperatureCelsius']
              }
              data_drives.push(dd)
            end
            ld = {
                'Size' => lds['CapacityMiB'],
                'Raid' => lds['Raid'],
                'Status' => lds['Status']['State'],
                'Health' => lds['Status']['Health'],
                'DataDrives' => data_drives
              }
              logical_drives.push(ld)
          end
          ac = {
            'Model' => controller['Model'],
            'SerialNumber' => controller['SerialNumber'],
            'State' => controller['Status']['State'],
            'Health' => controller['Status']['Health'],
            'Location' => controller['Location'],
            'FirmWareVersion' => controller['FirmwareVersion']['Current']['VersionString'],
            'LogicalDrives' => logical_drives,
            'Enclosures' => storage_enclosures
          }
          array_controllers.push(ac)
        end
      end
      {
        'HPSmartStorage' => {
          'Health' => storages['Status']['Health'],
          'ArrayControllers' => array_controllers
        }
      }
    end
  end
end
