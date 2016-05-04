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

    def apply_license(machine, license_key)
      options = {"LicenseKey"=> license_key}
      binding.pry
      rest_api(:post, '/redfish/v1/Managers/1/LicenseService/1', machine, options )
    end
  end
end
