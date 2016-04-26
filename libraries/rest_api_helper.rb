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

    def reset_server(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "ForceRestart"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/redfish/v1/systems/', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end

    def get_power_state(machine)
      sysget = rest_api(:get, '/redfish/v1/systems/', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:get, sysuri, machine)["PowerState"]
    end

    def power_on(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "On"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/redfish/v1/systems/', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end

    def power_off(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "ForceOff"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/redfish/v1/systems/', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end


    def findILOMacAddr(machine)
      iloget = rest_api(:get, '/redfish/v1/Managers/1/NICs/', machine)
      iloget["Items"][0]["MacAddress"]
    end

    def reset_ilo(machine)
      newAction = {"Action"=> "Reset"}
      options = {'body' => newAction}
      mgrget = rest_api(:get, '/redfish/v1/Managers/', machine)
      mgruri = mgrget["links"]["Member"][0]["href"]
      rest_api(:post, mgruri ,machine ,options )
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

    def clear_iel_logs(machine)
      newAction = {"Action"=> "ClearLog"}
      options = {'body' => newAction}
      rest_api(:post, '/redfish/v1/Managers/1/LogServices/IEL/', machine, options)
    end

    def clear_iml_logs(machine)
      newAction = {"Action"=> "ClearLog"}
      options = {'body' => newAction}
      rest_api(:post, '/redfish/v1/Systems/1/LogServices/IML/', machine, options)
    end

    def dump_iel_logs(machine,ilo,severity_level,file,duration)
      entries = rest_api(:get, '/redfish/v1/Managers/1/LogServices/IEL/Entries/', machine)["links"]["Member"]
      entries.each do |e|
        logs = rest_api(:get, e["href"], machine)
        severity = logs["Severity"]
        message = logs["Message"]
        created = logs["Created"]
        if !severity_level.nil?
          ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if created == severity_level and Time.parse(created) > (Time.now.utc - (duration*3600))
        else
          ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if Time.parse(created) > (Time.now.utc - (duration*3600))
        end
        File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
      end
    end

    def dump_iml_logs(machine, ilo, severity_level,file,duration)
      entries = rest_api(:get, '/redfish/v1/Systems/1/LogServices/IML/Entries/', machine)["links"]["Member"]
      entries.each do |e|
        logs = rest_api(:get, e["href"], machine)
        severity = logs["Severity"]
        message = logs["Message"]
        created = logs["Created"]
        if !severity_level.nil?
          ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if created == severity_level and Time.parse(created) > (Time.now.utc - (duration*3600))
        else
          ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if Time.parse(created) > (Time.now.utc - (duration*3600))
        end
        File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
      end
    end

    def enable_uefi_secure_boot(machine, value)
      newAction = {"SecureBootEnable"=> value}
      options = {'body' => newAction}
      rest_api(:patch, '/redfish/v1/Systems/1/SecureBoot/', machine, options)
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

    def get_schema(machine, schema_prefix, schema_file)
      schemas = rest_api(:get, '/redfish/v1/Schemas/', machine)["Items"]
      schema = schemas.select{|schema| schema["Schema"].start_with?(schema_prefix)}
      raise "NO schema found with this schema prefix : #{schema_prefix}" if schema.empty?
      schema.each do |sc|
        schema_store = rest_api(:get, sc["Location"][0]["Uri"]["extref"], machine)
        File.open("#{Chef::Config[:file_cache_path]}/#{schema_file}.txt", 'a+') {|f| f.write(schema_store.to_yaml)}
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
