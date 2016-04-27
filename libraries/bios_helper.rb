module ILO_SDK
  # Contains helper methods for Bios actions
  module Bios_Helper
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

    #def get_bios_resource(machine)
    #  sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
    #  bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href'] #/redfish/v1/Systems/1/bios/
    #  rest_api(:get, bios_uri, machine)
    #end

   #def revert_bios(machine)
   # sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
   # bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
   # bios = rest_api(:get, bios_uri, machine)
   # bios_baseconfigs_uri = bios['links']['BaseConfigs']['href']
   # bios_settings_uri = bios['links']['Settings']['href']  ##"/rest/v1/systems/1/bios/Settings"
   # newAction = {"BaseConfig" => "default"}
   # options = {'body' => newAction}
   # binding.pry
   # rest_api(:patch, bios_settings_uri, machine, options)
   #end
   
    def revert_bios
      newAction = {"BaseConfig" => "default"}
      response = rest_patch('/rest/v1/systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end

    #def set_uefi_shell_startup(machine, value, location, url)
      #bios_settings = get_bios_resource(machine)['links']['Settings']['href']
      #newAction = {"UefiShellStartup" => value, "UefiShellStartupLocation" => location, "UefiShellStartupUrl" => url}
      #options = {'body' => newAction}
      #rest_api(:patch, bios_settings, machine, options)
    #end

    def get_uefi_shell_startup
      response = rest_get('/redfish/v1/Systems/1/bios/')
      bios = response_handler('/redfish/v1/Systems/1/bios/')
      {
        'UefiShellStartup' => bios['UefiShellStartup'],
        'UefiShellStartupLocation' => bios['UefiShellStartupLocation'],
        'UefiShellStartupUrl' => bios['UefiShellStartupUrl']
      }
    end

    def set_uefi_shell_startup(value, location, url)
      newAction = {
        'UefiShellStartup' => value,
        'UefiShellStartupLocation' => location,
        'UefiShellStartupUrl' => url
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/', body: newAction)
      response_handler(response)
      true
    end

    #def set_bios_dhcp(machine, value, ipv4_address='', ipv4_primary_dns='', ipv4_secondary_dns='', ipv4_gateway='', ipv4_subnet_mask='')
      #bios_settings = get_bios_resource(machine)['links']['Settings']['href']
      #newAction = {
      #  'Dhcpv4' => value,
      #  'Ipv4Address' => ipv4_address,
      #  'Ipv4Gateway' => ipv4_gateway,
      #  'Ipv4PrimaryDNS' => ipv4_primary_dns,
      #  'Ipv4SecondaryDNS' => ipv4_secondary_dns,
      #  'Ipv4SubnetMask' => ipv4_subnet_mask
      #}
      #options = {'body' => newAction}
      #rest_api(:patch, bios_settings, machine, options)
    #end

    def get_bios_dhcp
      response = rest_get('/redfish/v1/Systems/1/bios/')
      bios = response_handler('/redfish/v1/Systems/1/bios/')
      {
        'Dhcpv4' => bios['Dhcpv4'],
        'Ipv4Address' => bios['Ipv4Address'],
        'Ipv4Gateway' => bios['Ipv4Gateway'],
        'Ipv4PrimaryDNS' => bios['Ipv4PrimaryDNS'],
        'Ipv4SecondaryDNS' => bios['Ipv4SecondaryDNS'],
        'Ipv4SubnetMask' => bios['Ipv4SubnetMask']
      }
    end

    def set_bios_dhcp(value, ipv4_address='', ipv4_gateway='', ipv4_primary_dns='', ipv4_secondary_dns='', ipv4_subnet_mask='')
      newAction = {
        'Dhcpv4' => value,
        'Ipv4Address' => ipv4_address,
        'Ipv4Gateway' => ipv4_gateway,
        'Ipv4PrimaryDNS' => ipv4_primary_dns,
        'Ipv4SecondaryDNS' => ipv4_secondary_dns,
        'Ipv4SubnetMask' => ipv4_subnet_mask
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/', body: newAction)
      response_handler(response)
      true
    end

    #def set_url_boot_file(machine, url)
    #  bios_settings = get_bios_resource(machine)['links']['Settings']['href']
    #  newAction = {'UrlBootFile' => url}
    #  options = {'body' => newAction}
    #  rest_api(:patch, bios_settings, machine, options)
    #end

    def get_url_boot_file
      response = rest_get('/redfish/v1/Systems/1/bios/')
      response_handler('/redfish/v1/Systems/1/bios/')['UrlBootFile']
    end

    def set_url_boot_file(url)
      newAction = {'UrlBootFile' => url}
      response = rest_patch('/redfish/v1/Systems/1/bios/', body: newAction)
      response_handler(response)
      true
    end

    #def set_bios_service(machine, name, email)
    #  bios_settings = get_bios_resource(machine)['links']['Settings']['href']
    #  newAction = {'ServiceName' => name, 'ServiceEmail' => email}
    #  options = {'body' => newAction}
    #  rest_api(:patch, bios_settings, machine, options)
    #end

    def get_bios_service
      response = rest_get('/redfish/v1/Systems/1/bios/')
      bios = response_handler('/redfish/v1/Systems/1/bios/')
      {
        'ServiceName' => bios['ServiceName'],
        'ServiceEmail' => bios['ServiceEmail']
      }
    end

    def set_bios_service(name, email)
      newAction = {
        'ServiceName' => name,
        'ServiceEmail' => email
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/', body: newAction)
      response_handler(response)
      true
    end
  end
end
