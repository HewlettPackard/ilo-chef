module ILO_SDK
  # Contains helper methods for Bios actions
  module Bios_Helper
    # Revert the BIOS
    # @raise [RuntimeError] if the request failed
    # @return true
    def revert_bios
      newAction = {"BaseConfig" => "default"}
      response = rest_patch('/redfish/v1/systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end

    # Get the UEFI shell start up
    # @raise [RuntimeError] if the request failed
    # @return [String] uefi_shell_startup
    def get_uefi_shell_startup
      response = rest_get('/redfish/v1/Systems/1/bios/Settings/')
      bios = response_handler(response)
      {
        'UefiShellStartup' => bios['UefiShellStartup'],
        'UefiShellStartupLocation' => bios['UefiShellStartupLocation'],
        'UefiShellStartupUrl' => bios['UefiShellStartupUrl']
      }
    end

    # Set the UEFI shell start up
    # @param [String, Symbol] value
    # @param [String, Symbol] location
    # @param [String, Symbol] url
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_uefi_shell_startup(value, location, url)
      newAction = {
        'UefiShellStartup' => value,
        'UefiShellStartupLocation' => location,
        'UefiShellStartupUrl' => url
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end

    # Get the BIOS DHCP
    # @raise [RuntimeError] if the request failed
    # @return [String] uefi_bios_dhcp
    def get_bios_dhcp
      response = rest_get('/redfish/v1/Systems/1/bios/Settings/')
      bios = response_handler(response)
      {
        'Dhcpv4' => bios['Dhcpv4'],
        'Ipv4Address' => bios['Ipv4Address'],
        'Ipv4Gateway' => bios['Ipv4Gateway'],
        'Ipv4PrimaryDNS' => bios['Ipv4PrimaryDNS'],
        'Ipv4SecondaryDNS' => bios['Ipv4SecondaryDNS'],
        'Ipv4SubnetMask' => bios['Ipv4SubnetMask']
      }
    end

    # Set the UEFI shell start up
    # @param [String, Symbol] value
    # @param [String, Symbol] ipv4_address
    # @param [String, Symbol] ipv4_gateway
    # @param [String, Symbol] ipv4_primary_dns
    # @param [String, Symbol] ipv4_secondary_dns
    # @param [String, Symbol] ipv4_subnet_mask
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_bios_dhcp(value, ipv4_address='', ipv4_gateway='', ipv4_primary_dns='', ipv4_secondary_dns='', ipv4_subnet_mask='')
      newAction = {
        'Dhcpv4' => value,
        'Ipv4Address' => ipv4_address,
        'Ipv4Gateway' => ipv4_gateway,
        'Ipv4PrimaryDNS' => ipv4_primary_dns,
        'Ipv4SecondaryDNS' => ipv4_secondary_dns,
        'Ipv4SubnetMask' => ipv4_subnet_mask
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end

    # Get the URL boot file
    # @raise [RuntimeError] if the request failed
    # @return [String] url_boot_file
    def get_url_boot_file
      response = rest_get('/redfish/v1/Systems/1/bios/Settings/')
      response_handler(response)['UrlBootFile']
    end

    # Set the UEFI shell start up
    # @param [String, Symbol] url_boot_file
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_url_boot_file(url_boot_file)
      newAction = {'UrlBootFile' => url_boot_file}
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end

    # Get the BIOS service
    # @raise [RuntimeError] if the request failed
    # @return [String] bios_service
    def get_bios_service
      response = rest_get('/redfish/v1/Systems/1/bios/Settings/')
      bios = response_handler(response)
      {
        'ServiceName' => bios['ServiceName'],
        'ServiceEmail' => bios['ServiceEmail']
      }
    end

    # Set the BIOS service
    # @param [String, Symbol] name
    # @param [String, Symbol] email
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_bios_service(name, email)
      newAction = {
        'ServiceName' => name,
        'ServiceEmail' => email
      }
      response = rest_patch('/redfish/v1/Systems/1/bios/Settings/', body: newAction)
      response_handler(response)
      true
    end
  end
end
