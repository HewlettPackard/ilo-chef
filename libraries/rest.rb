module ILO_SDK
  # Contains all the methods for making API REST calls
  module Rest
    # Make a restful API request to the iLO
    # @param [Symbol] type the rest method/type Options are :get, :post, :put, :patch, and :delete
    # @param [String] path the path for the request. Usually starts with "/rest/"
    # @param [Hash] options the options for the request
    # @option options [String] :body Hash to be converted into json and set as the request body
    # @option options [String] :Content-Type ('application/json') Set to nil or :none to have this option removed
    # @return [NetHTTPResponse] The response object
    def rest_api(type, path, options = {})
      fail 'Must specify path' unless path
      fail 'Must specify type' unless type
      @logger.debug "Making :#{type} rest call to #{@host}#{path}"

      uri = URI.parse(URI.escape("https://" + @host + path))
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE unless @ssl_enabled

      request = build_request(type, uri, options)
      response = http.request(request)
      @logger.debug "  Response: Code=#{response.code}. Headers=#{response.to_hash}\n  Body=#{response.body}"
      response
    rescue OpenSSL::SSL::SSLError => e
      msg = 'SSL verification failed for request. Please either:'
      msg += "\n  1. Install the certificate into your cert store"
      msg += ". Using cert store: #{ENV['SSL_CERT_FILE']}" if ENV['SSL_CERT_FILE']
      msg += "\n  2. Set the :ssl_enabled option to false for your ilo client"
      raise "#{e.message}\n\n#{msg}\n\n"
    end

    # Make a restful GET request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_get(path)
      rest_api(:get, path, {})
    end

    # Make a restful POST request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_post(path, options = {})
      rest_api(:post, path, options)
    end

    # Make a restful PUT request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_put(path, options = {})
      rest_api(:put, path, options)
    end

    # Make a restful PATCH request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_patch(path, options = {})
      rest_api(:patch, path, options)
    end

    # Make a restful DELETE request
    # Parameters & return value align with those of the {ILO_SDK::Rest::rest_api} method above
    def rest_delete(path, options = {})
      rest_api(:delete, path, options)
    end

    RESPONSE_CODE_OK           = 200
    RESPONSE_CODE_CREATED      = 201
    RESPONSE_CODE_ACCEPTED     = 202
    RESPONSE_CODE_NO_CONTENT   = 204
    RESPONSE_CODE_BAD_REQUEST  = 400
    RESPONSE_CODE_UNAUTHORIZED = 401
    RESPONSE_CODE_NOT_FOUND    = 404

    # Handle the response for rest call.
    #   If an asynchronous task was started, this waits for it to complete.
    # @param [HTTPResponse] HTTP response
    # @raise [RuntimeError] if the request failed
    # @raise [RuntimeError] if a task was returned that did not complete successfully
    # @return [Hash] The parsed JSON body
    def response_handler(response)
      case response.code.to_i
      when RESPONSE_CODE_OK # Synchronous read/query
        begin
          return JSON.parse(response.body)
        rescue JSON::ParserError => e
          @logger.warn "Failed to parse JSON response. #{e}"
          return response.body
        end
      when RESPONSE_CODE_CREATED # Synchronous add
        return JSON.parse(response.body)
      when RESPONSE_CODE_ACCEPTED # Asynchronous add, update or delete
        return JSON.parse(response.body) # TODO: Remove when tested
        # TODO: Make this actually wait for the task
        @logger.debug "Waiting for task: response.header['location']"
        task = wait_for(response.header['location'])
        return true unless task['associatedResource'] && task['associatedResource']['resourceUri']
        resource_data = rest_get(task['associatedResource']['resourceUri'])
        return JSON.parse(resource_data.body)
      when RESPONSE_CODE_NO_CONTENT # Synchronous delete
        return {}
      when RESPONSE_CODE_BAD_REQUEST
        fail "400 BAD REQUEST #{response.body}"
      when RESPONSE_CODE_UNAUTHORIZED
        fail "401 UNAUTHORIZED #{response.body}"
      when RESPONSE_CODE_NOT_FOUND
        fail "404 NOT FOUND #{response.body}"
      else
        fail "#{response.code} #{response.body}"
      end
    end


    private

    def build_request(type, uri, options)
      case type.downcase
      when 'get', :get
        request = Net::HTTP::Get.new(uri.request_uri)
      when 'post', :post
        request = Net::HTTP::Post.new(uri.request_uri)
      when 'put', :put
        request = Net::HTTP::Put.new(uri.request_uri)
      when 'patch', :patch
        request = Net::HTTP::Patch.new(uri.request_uri)
      when 'delete', :delete
        request = Net::HTTP::Delete.new(uri.request_uri)
      else
        fail "Invalid rest call: #{type}"
      end
      options['Content-Type'] ||= 'application/json'
      options.delete('Content-Type')  if [:none, 'none', nil].include?(options['Content-Type'])
      auth = true
      if [:none, 'none'].include?(options['auth'])
        options.delete('auth')
        auth = false
      end
      options.each do |key, val|
        if key.to_s.downcase == 'body'
          request.body = val.to_json rescue val
        else
          request[key] = val
        end
      end

      filtered_options = options.to_s
      filtered_options.gsub!(@password, 'filtered') if @password
      @logger.debug "  Options: #{filtered_options}"

      request.basic_auth(@user, @password) if auth
      request
    end

  end
end
