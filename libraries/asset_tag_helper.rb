module ILO_SDK
  # Contains helper methods for indicator LED actions
  module Asset_Tag_Helper
    # Get the Asset Tag
    # @raise [RuntimeError] if the request failed
    # @return [String] asset_tag
    def get_asset_tag
      response = rest_get('/redfish/v1/Systems/1/')
      response_handler(response)['AssetTag']
    end

    # Set the Asset Tag
    # @param [String, Symbol] asset_tag
    # @raise [RuntimeError] if the request failed
    # @return true
    def set_asset_tag(asset_tag)
      newAction = {"AssetTag" => asset_tag}
      response = rest_patch('/redfish/v1/Systems/1/', body: newAction)
      response_handler(response)
      true
    end
  end
end
