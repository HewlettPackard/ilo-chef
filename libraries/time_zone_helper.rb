module ILO_SDK
  # Contains helper methods for indicator LED actions
  module Time_Zone_Helper
    # Get the Time Zone
    # @raise [RuntimeError] if the request failed
    # @return [String] time_zone
    def get_time_zone
      response = rest_get('/redfish/v1/Managers/1/DateTime/')
      response_handler(response)["TimeZone"]["Name"]
    end

    # Set the Time Zone
    # @param [Fixnum] time_zone
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_time_zone(time_zone)
      time_response = rest_get('/redfish/v1/Managers/1/DateTime/')
      newTimeZone = response_handler(time_response)['TimeZoneList'].select{|timezone| timezone["Name"] == time_zone}
      newAction = {"TimeZone" => {"Index" => newTimeZone[0]["Index"]}}
      response = rest_patch('/redfish/v1/Managers/1/DateTime/', body: newAction)
      response_handler(response)
      true
    end

    # Get whether or not ntp servers are being used
    # @raise [RuntimeError] if the request failed
    # @return [TrueClass, FalseClass] value
    def get_ntp
      response = rest_get('/redfish/v1/Managers/1/EthernetInterfaces/1/')
      response_handler(response)["Oem"]["Hp"]["DHCPv4"]["UseNTPServers"]
    end

    # Set whether or not ntp servers are being used
    # @param [TrueClass, FalseClass] value
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ntp(value)
      newAction = {"Oem" => {"Hp" => {"DHCPv4" => {"UseNTPServers" => value}}}}
      response = rest_patch('/redfish/v1/Managers/1/EthernetInterfaces/1/', body: newAction)
      response_handler(response)
      true
    end

    # Get the NTP Servers
    # @raise [RuntimeError] if the request failed
    # @return [Array] ntp_servers
    def get_ntp_servers
      response = rest_get('/redfish/v1/Managers/1/DateTime/')
      response_handler(response)["StaticNTPServers"]
    end

    # Set the NTP Servers
    # @param [Fixnum] ntp_servers
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_ntp_servers(ntp_servers)
      newAction = {'StaticNTPServers' => ntp_servers}
      response = rest_patch('/redfish/v1/Managers/1/DateTime/', body: newAction)
      response_handler(response)
      true
    end

  end
end
