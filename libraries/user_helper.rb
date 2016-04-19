module ILO_SDK
  # Contains helper methods for user actions
  module User_Helper
    # Get the UID indicator LED state
    # @raise [RuntimeError] if the request failed
    # @return [String] state
    #def get_indicator_led
    #  response = rest_get('/redfish/v1/Systems/1/')
    #  response_handler(response)['IndicatorLED']
    #end

    # Set the UID indicator LED
    # @param [String, Symbol] State
    # @raise [RuntimeError] if the request failed
    # @return true
    #def set_indicator_led(state)
    #  newAction = { 'IndicatorLED' => state }
    #  response = rest_patch('/redfish/v1/Systems/1/', body: newAction)
    #  response_handler(response)
    #  true
    #end
    #def reset_user_password(machine, modUserName, modPassword)
    #  uad = rest_api(:get, '/redfish/v1/AccountService/Accounts/', machine)
    #  userhref = adminhref(uad, modUserName)
    #  options = {
    #    'body' => modPassword
    #  }
    #  rest_api(:patch, userhref, machine, options)
    #end

    #def delete_user(deleteUserName, machine)
    #  uad = rest_api(:get, '/redfish/v1/AccountService/Accounts/', machine)
    #  minhref = adminhref(uad, deleteUserName )
    #  rest_api(:delete, minhref, machine)
    #end

    #def get_users(machine)
    #  rest_api(:get, '/rest/v1/AccountService/Accounts', machine)["Items"].collect{|user| user["UserName"]}
    #end

    #def create_user(machine,username,password)
    #  rest_api(:get, '/rest/v1/AccountService/Accounts', machine)
    #  newUser = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username} }}
    #  options = {'body' => newUser}
    #  rest_api(:post, '/redfish/v1/AccountService/Accounts/', machine,  options)
    #end
    def userhref(uri, username)
      response = rest_get(uri)
      items = response_handler(response)['Items']
      items.each do |it|
        if it['UserName'] == username
          return it['links']['self']['href']
        end
      end
    end

    def get_users
      response = rest_get('/redfish/v1/AccountService/Accounts/')
      response_handler(response)['Items'].collect{|user| user['Username']}
    end

    def create_user(username, password)
      newAction = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username}}}
      response = rest_post('/redfish/v1/AccountService/Accounts/', body: newAction)
      true
    end

    def reset_user_password(username, password)
      userhref = userhref('/redfish/v1/AccountService/Accounts/', username)
      newAction = {}
      response = rest_patch(userhref, body: newAction)
      true
    end

    def delete_user(username)

    end
  end
end
