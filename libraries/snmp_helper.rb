module ILO_SDK
  # Contains helper methods for snmp actions
  module SNMP_Helper
    # Get the SNMP Mode
    # @raise [RuntimeError] if the request failed
    # @return [String] mode
    def get_snmp_mode
      response = rest_get('/redfish/v1/Managers/1/SnmpService/')
      response_handler(response)['Mode']
    end

    # Get the SNMP Alerts Enabled value
    # @raise [RuntimeError] if the request failed
    # @return [String] alerts_enabled
    def get_snmp_alerts_enabled
      response = rest_get('/redfish/v1/Managers/1/SnmpService/')
      response_handler(response)['AlertsEnabled']
    end

    # Set the SNMP Mode and Alerts Enabled value
    # @param [String, Symbol] snmp_mode, snmp_alerts
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_snmp(snmp_mode, snmp_alerts)
      newAction = {'Mode' => snmp_mode, 'AlertsEnabled' =>  snmp_alerts}
      response = rest_patch('/redfish/v1/Managers/1/SnmpService/', body: newAction)
      response_handler(response)
      true
    end
  end
end
