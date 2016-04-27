require 'pry'
require 'base64'
require 'net/http'
require 'time'
require 'yaml'

module RestAPI
  module Helper
    include Chef::Mixin::ShellOut

    def adminhref(uad, userName)
      minhref=nil
      uad["Items"].each do |account|
        if account["UserName"] == userName
          minhref=account["links"]["self"]["href"]
          return minhref
        end
      end
      fail "Could not find user account #{userName}"
    end

    def rest_api(type, path, machine, options = {})
      disable_ssl = true
      uri = URI.parse(URI.escape("https://" + machine['ilo_site'] + path))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE if disable_ssl
      case type.downcase
      when 'get', :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'post', :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when 'put', :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when 'delete', :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      when 'patch', :patch
        request = Net::HTTP::Patch.new(uri.request_uri)
      else
        fail "Invalid rest call: #{type}"
      end
      options['Content-Type'] ||= 'application/json'
      options.each do |key, val|
        if key.downcase == 'body'
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end
      request.basic_auth(machine["username"], machine["password"])
      response = http.request(request)
      JSON.parse(response.body) rescue response
    end

    def get_fw_version(machine)
      rest_api(:get, '/redfish/v1/Systems/1/FirmWareInventory/', machine)["Current"]["SystemBMC"][0]["VersionString"]
    end

    def fw_upgrade(machine,uri)
      newAction = {"Action"=> "InstallFromURI", "FirmwareURI"=> uri}
      options = {'body' => newAction}
      rest_api(:post, '/redfish/v1/Managers/1/UpdateService/', machine, options)
    end

    def apply_license(machine, license_key)
      options = {"LicenseKey"=> license_key}
      binding.pry
      rest_api(:post, '/redfish/v1/Managers/1/LicenseService/1', machine, options )
    end

    # def revert_bios_settings(machine)
    #   newAction = {"BaseConfig" => "default"}
    #   options = {'body' => newAction}
    #   rest_api(:put, '/redfish/v1/Systems/1/BIOS/Settings/',machine,options)
    # end
    #
    # def reset_boot_order(machine)
    #   newAction = {"RestoreManufacturingDefaults" => "yes"}
    #   options = {'body' => newAction}
    #   binding.pry
    #   rest_api(:patch, '/redfish/v1/Systems/1/BIOS/Settings/',machine,options)
    # end

      def mount_virtual_media(machine, iso_uri, boot_on_next_server_reset)
        rest_api(:get, '/redfish/v1/Managers/1/VirtualMedia/', machine)["links"]["Member"].each do |vm|
          virtual_media = rest_api(:get,vm["href"],machine)
          next if !(virtual_media["MediaTypes"].include?("CD") || virtual_media["MediaTypes"].include?("DVD"))
          mount = {'Image' =>  iso_uri}
          mount['Oem'] = {'Hp' =>  {'BootOnNextServerReset' =>  boot_on_next_server_reset}}
          newAction = mount
          options = {'body' => newAction}
          rest_api(:patch,vm["href"],machine,options)
        end
      end

   def get_bios_resource(machine)
     sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
     bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
     rest_api(:get, bios_uri, machine)
   end

  def revert_bios(machine)
    sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
    bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
    bios = rest_api(:get, bios_uri, machine)
    bios_baseconfigs_uri = bios['links']['BaseConfigs']['href']
    bios_settings_uri = bios['links']['Settings']['href']  ##"/rest/v1/systems/1/bios/Settings"
    newAction = {"BaseConfig" => "default"}
    options = {'body' => newAction}
    binding.pry
    rest_api(:patch, bios_settings_uri, machine, options)
  end

   def set_uefi_shell_startup(machine, value, location, url)
     bios_settings = get_bios_resource(machine)['links']['Settings']['href']
     newAction = {"UefiShellStartup" => value, "UefiShellStartupLocation" => location, "UefiShellStartupUrl" => url}
     options = {'body' => newAction}
     rest_api(:patch, bios_settings, machine, options)
   end

   def set_bios_dhcp(machine, value, ipv4_address='', ipv4_primary_dns='', ipv4_secondary_dns='', ipv4_gateway='', ipv4_subnet_mask='')
     bios_settings = get_bios_resource(machine)['links']['Settings']['href']
     newAction = {
       'Dhcpv4' => value,
       'Ipv4Address' => ipv4_address,
       'Ipv4Gateway' => ipv4_gateway,
       'Ipv4PrimaryDNS' => ipv4_primary_dns,
       'Ipv4SecondaryDNS' => ipv4_secondary_dns,
       'Ipv4SubnetMask' => ipv4_subnet_mask
     }
     options = {'body' => newAction}
     rest_api(:patch, bios_settings, machine, options)
   end

   def set_url_boot_file(machine, url)
     bios_settings = get_bios_resource(machine)['links']['Settings']['href']
     newAction = {'UrlBootFile' => url}
     options = {'body' => newAction}
     rest_api(:patch, bios_settings, machine, options)
   end

   def set_bios_service(machine, name, email)
     bios_settings = get_bios_resource(machine)['links']['Settings']['href']
     newAction = {'ServiceName' => name, 'ServiceEmail' => email}
     options = {'body' => newAction}
     rest_api(:patch, bios_settings, machine, options)
   end


  end
end
