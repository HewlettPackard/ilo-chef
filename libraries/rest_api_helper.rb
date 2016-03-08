require 'pry'
require 'base64'
require 'net/http'
require 'time'

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
      uri = URI.parse(URI.escape(machine['ilo_site'] + path))
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
      #User account information
      uad = rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
      #User account url
      userhref = adminhref(uad, modUserName)
      options = {
        'body' => modPassword
      }
      rest_api(:patch, userhref, machine, options)
    end

    def delete_user(deleteUserName, machine)
      uad = rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
      minhref = adminhref(uad, deleteUserName )
      rest_api(:delete, minhref, machine)
    end

    def reset_server(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "ForceRestart"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/rest/v1/systems', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end

    def power_on(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "On"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/rest/v1/systems', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end

    def power_off(machine)
      newAction = {"Action"=> "Reset", "ResetType"=> "ForceOff"}
      options = {'body' => newAction}
      sysget = rest_api(:get, '/rest/v1/systems', machine)
      sysuri = sysget["links"]["Member"][0]["href"]
      rest_api(:post, sysuri, machine, options)
    end


    def findILOMacAddr(machine)
      iloget = rest_api(:get, '/rest/v1/Managers/1/NICs', machine)
      iloget["Items"][0]["MacAddress"]
    end

    def resetILO(machine)
      newAction = {"Action"=> "Reset"}
      options = {'body' => newAction}
      mgrget = rest_api(:get, '/rest/v1/Managers', machine)
      mgruri = mgrget["links"]["Member"][0]["href"]
      rest_api(:post, mgruri ,machine ,options )
    end

    def create_user(machine,username,password)
      rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
  		newUser = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username} }}
  		options = {'body' => newUser}
  		rest_api(:post, '/rest/v1/AccountService/Accounts', machine,  options)
    end

    def fw_upgrade(machine,uri)
      newAction = {"Action"=> "InstallFromURI", "FirmwareURI"=> uri}
      options = {'body' => newAction}
      binding.pry
      rest_api(:post, '/rest/v1/Managers/1/UpdateService', machine, options)
    end

    def apply_license(machine, license_key)
      newAction = {"LicenseKey"=> license_key}
      options = {'body' => newAction}
      rest_api(:post, '/rest/v1/Managers/1/LicenseService/1', machine, options )
    end

    def clear_iel_logs(machine)
      newAction = {"Action"=> "ClearLog"}
      options = {'body' => newAction}
      rest_api(:post, '/rest/v1/Managers/1/LogServices/IEL', machine, options)
    end

    def clear_iml_logs(machine)
      newAction = {"Action"=> "ClearLog"}
      options = {'body' => newAction}
      rest_api(:post, '/rest/v1/Systems/1/LogServices/IML', machine, options)
    end

    def dump_iel_logs(machine,ilo,severity_level,file,duration)
      entries = rest_api(:get, '/rest/v1/Managers/1/LogServices/IEL/Entries', machine)["links"]["Member"]
      severity_level = "OK" || "Warning" || "Critical" if severity_level == "any"
      entries.each do |e|
        logs = rest_api(:get, e["href"], machine)
        severity = logs["Severity"]
        message = logs["Message"]
        created = logs["Created"]
        ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if severity == severity_level and Time.parse(created) > (Time.parse(created) - (duration*3600))
        File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
      end
    end

    def dump_iml_logs(machine, ilo, severity_level,file,duration)
      entries = rest_api(:get, '/rest/v1/Systems/1/LogServices/IML/Entries', machine)["links"]["Member"]
      severity_level = "OK" || "Warning" || "Critical" if severity_level == "any"
      entries.each do |e|
        logs = rest_api(:get, e["href"], machine)
        severity = logs["Severity"]
        message = logs["Message"]
        created = logs["Created"]
        ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if severity == severity_level and Time.parse(created) > (Time.parse(created) - (duration))
        File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
      end
    end

    def enable_uefi_secure_boot(machine, value)
      newAction = {"SecureBootEnable"=> value}
      options = {'body' => newAction}
      rest_api(:patch, '/rest/v1/Systems/1/SecureBoot', machine, options)
    end

    def revert_bios_settings(machine)
      newAction = {"BaseConfig" => "default"}
      options = {'body' => newAction}
      rest_api(:put, '/rest/v1/Systems/1/BIOS/Settings',machine,options)
    end

    def reset_boot_order(machine)
      newAction = {"RestoreManufacturingDefaults" => "yes"}
      options = {'body' => newAction}
      rest_api(:patch, '/rest/v1/Systems/1/BIOS',machine,options)
    end

    def set_ilo_time_zone(machine, time_zone_index)
      timezone = rest_api(:get, '/rest/v1/Managers/1/DateTime',machine)
      puts "Current TimeZone is: " + timezone["TimeZone"]["Name"]
      newAction = {"TimeZone" => {"Index" => time_zone_index}}
      options = {'body' => newAction}
      out = rest_api(:patch, '/rest/v1/Managers/1/DateTime', machine, options)
      raise "SNTP Configuration is managed by DHCP and is read only" if out["Messages"][0]["MessageID"] ==  "iLO.0.10.SNTPConfigurationManagedByDHCPAndIsReadOnly"
      timezone = rest_api(:get, '/rest/v1/Managers/1/DateTime',machine)
      puts "TimeZone set to: " + timezone["TimeZone"]["Name"]
    end

    def use_ntp_servers(machine,value)
      newAction = {"Oem" => {"Hp" => {"DHCPv4" => {"UseNTPServers" => value}}}}
      options = {'body' => newAction}
      rest_api(:patch, '/rest/v1/Managers/1/EthernetInterfaces/1',machine,options)
    end

  end
end
