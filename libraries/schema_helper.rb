module ILO_SDK
  # Contains helper methods for Schema Actions
  module Schema_Helper
    # Get the schema information with given prefix
    # @param [String, Symbol] schema_prefix
    # @raise [RuntimeError] if the request failed
    # @return [String] schema
    def get_schema(schema_prefix)
      response = rest_get('/redfish/v1/Schemas/')
      schemas = response_handler(response)['Items']
      schema = schemas.select{|schema| schema["Schema"].start_with?(schema_prefix)}
      raise "NO schema found with this schema prefix : #{schema_prefix}" if schema.empty?
      info = []
      schema.each do |sc|
        response = rest_get(sc['Location'][0]['Uri']['extref'])
        schema_store = response_handler(response)
        info.push(schema_store)
      end
      return info
    end
  end
end
