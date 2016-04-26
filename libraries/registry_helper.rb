module ILO_SDK
  # Contains helper methods for Registry actions
  module Registry_Helper
    # Get the Registry with given registry_prefix
    # @param [String, Symbol] registry_prefix
    # @raise [RuntimeError] if the request failed
    # @return [String] info
    def get_registry(registry_prefix)
      response = rest_get('/redfish/v1/Registries/')
      registries = response_handler(response)['Items']
      registry = registries.select{|reg| reg["Schema"].start_with?(registry_prefix)}
      info = []
      registry.each do |reg|
        response = rest_get(reg['Location'][0]['Uri']['extref'])
        registry_store = response_handler(response)
        info.push(registry_store)
      end
      return info
    end
  end
end
