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

    def reset_user_password(machine, modUserName, modPassword)
      uad = rest_api(:get, '/redfish/v1/AccountService/Accounts/', machine)
      userhref = adminhref(uad, modUserName)
      options = {
        'body' => modPassword
      }
      rest_api(:patch, userhref, machine, options)
    end

    def delete_user(deleteUserName, machine)
      uad = rest_api(:get, '/redfish/v1/AccountService/Accounts/', machine)
      minhref = adminhref(uad, deleteUserName )
      rest_api(:delete, minhref, machine)
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

    def get_users(machine)
      rest_api(:get, '/rest/v1/AccountService/Accounts', machine)["Items"].collect{|user| user["UserName"]}
    end

    def create_user(machine,username,password)
      rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
      newUser = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username} }}
      options = {'body' => newUser}
      rest_api(:post, '/redfish/v1/AccountService/Accounts/', machine,  options)
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

    def set_ilo_time_zone(machine, time_zone)
      timezone = rest_api(:get, '/redfish/v1/Managers/1/DateTime/',machine)
      puts "Current TimeZone is: " + timezone["TimeZone"]["Name"]
      time_zone = rest_api(:get,'/redfish/v1/Managers/1/DateTime/',machine)['TimeZoneList'].select{|timezone| timezone["Name"] == time_zone}
      newAction = {"TimeZone" => {"Index" => time_zone[0]["Index"]}}
      options = {'body' => newAction}
      out = rest_api(:patch, '/redfish/v1/Managers/1/DateTime/', machine, options)
      raise "SNTP Configuration is managed by DHCP and is read only" if out["Messages"][0]["MessageID"] ==  "iLO.0.10.SNTPConfigurationManagedByDHCPAndIsReadOnly"
      timezone = rest_api(:get, '/redfish/v1/Managers/1/DateTime/',machine)
      puts "TimeZone set to: " + timezone["TimeZone"]["Name"]
    end

    def get_ilo_timeout(machine)
      rest_api(:get, '/redfish/v1/Managers/1/NetworkService/',machine)["SessionTimeoutMinutes"]
    end

    def set_ilo_timeout(machine, timeout)
      newAction = {"SessionTimeoutMinutes" => timeout}
      options = {'body' => newAction}
      out = rest_api(:patch, '/redfish/v1/Managers/1/NetworkService/', machine, options)
      raise "PropertyValueFormatError: Timeout can only be 15, 30, 60, 120, or infinite." if out["Messages"][0]["MessageID"] ==  "Base.0.10.PropertyValueFormatError"
    end

    def use_ntp_servers(machine,value)
      newAction = {"Oem" => {"Hp" => {"DHCPv4" => {"UseNTPServers" => value}}}}
      options = {'body' => newAction}
      rest_api(:patch, '/redfish/v1/Managers/1/EthernetInterfaces/1/',machine,options)
    end

    def gather_general_computer_details(machine)
      general_details = rest_api(:get, '/redfish/v1/Systems/1/',machine)
      manufacturer = general_details["Manufacturer"]
      model = general_details["Model"]
      asset_tag = general_details['AssetTag']
      bios_version = general_details['Bios']['Current']['VersionString']
      memory = general_details['Memory']['TotalSystemMemoryGB'].to_s + ' GB'
      processors = general_details['Processors']['Count'].to_s + ' x ' + general_details['Processors']['ProcessorFamily'].to_s
      {
        "#{machine['ilo_site']}" => {
          'manufacturer' => manufacturer,
          'model' => model,
          'AssetTag' => asset_tag,
          'bios_version' => bios_version,
          'memory' => memory,
          'processors' => processors}
        }
    end

      def gather_computer_network_details(machine)
        network_adapters = []
        networks =  rest_api(:get, rest_api(:get, '/redfish/v1/Systems/1/',machine)['Oem']['Hp']['links']['NetworkAdapters']['href'], machine)["links"]["Member"]
        networks.each do |network|
          network_detail = rest_api(:get, network["href"],machine)
          physical_ports = []
          network_detail['PhysicalPorts'].each do |port|
            n = {
              'Name' => port['Name'],
              'StructuredName' => port['Oem']['Hp']['StructuredName'],
              'MacAddress' => port['MacAddress'],
              'State' => port['Status']['State']
            }
            physical_ports.push(n)
          end
          nets = {'Name' => network_detail['Name'],
            'StructuredName' => network_detail['StructuredName'],
            'PartNumber'  =>  network_detail['PartNumber'],
            'State' => network_detail['Status']['State'],
            'Health' => network_detail['Status']['Health'],
            'PhysicalPorts' => physical_ports
          }
          network_adapters.push(nets)
        end
        {
          'NetworkAdapters' => network_adapters
        }
      end

      def gather_array_controller_details(machine)
        storages = rest_api(:get, rest_api(:get, '/redfish/v1/Systems/1/',machine)['Oem']['Hp']['links']['SmartStorage']['href'], machine)
        array_controllers = []
        array_ctrls = rest_api(:get, storages['links']['ArrayControllers']['href'],machine)
        if array_ctrls["links"].has_key?("Member")
          array_ctrls["links"]["Member"].each do |array_controller|
            controller = rest_api(:get, array_controller["href"],machine)
            storage_enclosures = []
            rest_api(:get, controller["links"]["StorageEnclosures"]["href"], machine)["links"]["Member"].each do |enclosure|
              enclsr = rest_api(:get, enclosure["href"], machine)
              enc = {
                'Model' => enclsr['Model'],
                'SerialNumber' => enclsr['SerialNumber'],
                'DriveBayCount' => enclsr['DriveBayCount'],
                'State' => enclsr['Status']['State'],
                'Health' => enclsr['Status']['Health'],
                'Location' => enclsr['Location'].to_s + ' (' + enclsr['LocationFormat'].to_s + ')',
                'FIrmwareVersion' => enclsr['FirmwareVersion']['Current']['VersionString']
              }
              storage_enclosures.push(enc)
            end

            logical_drives = []
            rest_api(:get, controller["links"]["LogicalDrives"]["href"],machine)["links"]["Member"].each do |logicaldrive|
              lds = rest_api(:get, logicaldrive["href"], machine)
              data_drives = []
              rest_api(:get, lds['links']['DataDrives']['href'],machine)["links"]["Member"].each do |datadrives|
                disk_drive = rest_api(:get,datadrives["href"],machine)
                dsk_drive = {
                  'Model' => disk_drive['Model'],
                  'Name' => disk_drive['Name'],
                  'RotationalSpeedRpm' => disk_drive['RotationalSpeedRpm'],
                  'SerialNumber' => disk_drive['SerialNumber'],
                  'State' => disk_drive['Status']['State'],
                  'Health' => disk_drive['Status']['Health'],
                  'CapacityMiB' => disk_drive['CapacityMiB'],
                  'CurrentTemperatureCelsius' => disk_drive['CurrentTemperatureCelsius']
                }
                data_drives.push(dsk_drive)
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
          'HPSmartStorage' =>   {
            'Health' => storages['Status']['Health'],
            'ArrayControllers' => array_controllers
          }
        }
      end

      def dump_computer_details(machine,dump_file)
        general_computer_details = gather_general_computer_details(machine)
        computer_network_details = gather_computer_network_details(machine)
        array_controller_details = gather_array_controller_details(machine)
        file = File.open("#{Chef::Config[:file_cache_path]}/#{dump_file}.txt", 'a+')
        file.write(general_computer_details.merge(computer_network_details).merge(array_controller_details).to_yaml)
        file.write("\n")
        file.close
      end

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

      def get_asset_tag(machine)
        rest_api(:get,'/redfish/v1/Systems/1/',machine)["AssetTag"]
      end

      def set_asset_tag(machine,tag)
        newAction = {"AssetTag" => tag}
        options = {'body' => newAction}
        rest_api(:patch,'/redfish/v1/Systems/1/',machine,options)
      end

     def configure_snmp(machine, snmp_mode, snmp_alerts)
       manager = rest_api(:get, '/redfish/v1/Managers/', machine)["links"]["Member"][0]["href"]
       network_service = rest_api(:get, manager, machine)['links']['NetworkService']['href']
       snmp_service = rest_api(:get, network_service,machine)['links']['SNMPService']['href']
       config = rest_api(:get, snmp_service, machine)
       puts "Current SNMP Configuration for #{machine['ilo_site']}: Mode - #{config["Mode"]}, AlertsEnabled - #{config["AlertsEnabled"]}"
       options = {'Mode' => snmp_mode, 'AlertsEnabled' =>  snmp_alerts}
       rest_api(:patch, snmp_service, machine, options)
       config = rest_api(:get, snmp_service, machine)
       puts "SNMP configuration for #{machine['ilo_site']} changed to : Mode - #{config["Mode"]}, AlertsEnabled - #{config["AlertsEnabled"]}"
     end

    def get_registry(machine, registry_prefix, registry_file)
      registries = rest_api(:get, '/redfish/v1/Registries/', machine)["Items"]
      registry = registries.select{|reg| reg["Schema"].start_with?(registry_prefix)}
      registry.each do |reg|
        registry_store = rest_api(:get, reg["Location"][0]["Uri"]["extref"], machine)
        File.open("#{Chef::Config[:file_cache_path]}/#{registry_file}.txt", 'a+') {|f| f.write(registry_store.to_yaml)}
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

    def get_boot_order(machine,boot_order_file)
      sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
      bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
      bios = rest_api(:get, bios_uri, machine)
      boot = rest_api(:get, bios['links']['Boot']['href'], machine)
      current_boot_order = {
        machine['ilo_site'] => boot['PersistentBootConfigOrder']
      }
      File.open("#{Chef::Config[:file_cache_path]}/#{boot_order_file}.txt", 'a+') {|f| f.write(current_boot_order.to_yaml)}
      return current_boot_order
    end

    def boot_order_change(machine, new_boot_order)
      sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
      bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
      bios = rest_api(:get, bios_uri, machine)
      boot_order = rest_api(:get, bios['links']['Boot']['href'], machine)
      puts "Current boot order for #{machine['ilo_site']} : #{boot_order['PersistentBootConfigOrder']}"
      options = {'body' => {'PersistentBootConfigOrder' => new_boot_order}}
      rest_api(:patch, boot_order['links']['Settings']['href'], machine, options)
      new_boot_order = rest_api(:get, bios['links']['Boot']['href'], machine)
      puts "New boot order for #{machine['ilo_site']} : #{boot_order['PersistentBootConfigOrder']}"
    end

    def get_temporary_boot_order(machine)
      sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
      bootSourceOverrideTarget = rest_api(:get, sys, machine)["Boot"]["BootSourceOverrideTarget"]
    end

    def boot_order_change_temporary(machine, boot_target)
      sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
      boottargets = rest_api(:get, sys, machine)["Boot"]["BootSourceOverrideSupported"]
      if boottargets.include?(boot_target)
        options = {'body' => {"Boot" => {"BootSourceOverrideTarget" => boot_target}}}
        rest_api(:patch, sys, machine,options)
      else
        raise "BootSourceOverrideTarget value - #{boot_target} is not supported. Valid values are: #{boottargets}"
      end
    end

   def get_boot_order_baseconfig(machine)
     sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
     bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
     bios = rest_api(:get, bios_uri, machine)
     boot_uri = bios['links']['Boot']['href']
     boot = rest_api(:get, boot_uri, machine)
     boot_settings_uri = boot['links']['Settings']['href']
     rest_api(:get, boot_settings_uri, machine)["BaseConfig"]
   end

   def boot_order_revert(machine)
     sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
     bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
     bios = rest_api(:get, bios_uri, machine)
     boot_uri = bios['links']['Boot']['href']
     boot = rest_api(:get, boot_uri, machine)
     boot_baseconfigs_uri = boot['links']['BaseConfigs']['href']
     default_boot_order = rest_api(:get, boot_baseconfigs_uri, machine)['BaseConfigs'][0]['default']['DefaultBootOrder']
     puts "Default boot order for #{machine['ilo_site']} : #{default_boot_order}"
     boot_settings_uri = boot['links']['Settings']['href'] ## "/rest/v1/systems/1/bios/Boot/Settings"
     newAction = {"BaseConfig" => "default"}
     options = {'body' => newAction}
     rest_api(:patch, boot_settings_uri, machine, options)
   end

   def get_bios_resource(machine)
     sys = rest_api(:get, '/redfish/v1/Systems/', machine)["links"]["Member"][0]["href"]
     bios_uri = rest_api(:get, sys, machine)['Oem']['Hp']['links']['BIOS']['href']
     rest_api(:get, bios_uri, machine)
   end

  def set_ntp_servers(machine, ntp_servers)
    manager = rest_api(:get, '/redfish/v1/Managers/', machine)["links"]["Member"][0]["href"]
    datetime_service = rest_api(:get, manager, machine)['Oem']['Hp']['links']['DateTimeService']['href']
    datetime = rest_api(:get, datetime_service, machine)
    puts "Current NTP servers for #{machine['ilo_site']} - #{datetime['NTPServers']}"
    options = {'body' => {'StaticNTPServers' => ntp_servers}}
    out = rest_api(:patch, datetime_service, machine, options)
    raise "SNTP Configuration is managed by DHCP and is read only" if out["Messages"][0]["MessageID"] ==  "iLO.0.10.SNTPConfigurationManagedByDHCPAndIsReadOnly"
    datetime = rest_api(:get, datetime_service, machine)
    puts "NTP servers for #{machine['ilo_site']} set to : #{datetime['NTPServers']}"
    puts "May Require an ilo reset to become active"
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
