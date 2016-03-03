require 'pry'
require 'base64'
require 'net/http'

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
  end
end
