module ILO_SDK
  # Contains helper methods for user actions
  module User_Helper
    def userhref(uri, username)
      response = rest_get(uri)
      items = response_handler(response)['Items']
      items.each do |it|
        if it['UserName'] == username
          return it['links']['self']['href']
        end
      end
    end

    # Get the users
    # @raise [RuntimeError] if the request failed
    # @return [String] users
    def get_users
      response = rest_get('/redfish/v1/AccountService/Accounts/')
      items = response_handler(response)['Items'].collect{|user| user['UserName']}
    end

    # Create a user
    # @param [String, Symbol] username
    # @param [String, Symbol] password
    # @raise [RuntimeError] if the request failed
    # @return true
    def create_user(username, password)
      newAction = {"UserName" => username, "Password"=> password, "Oem" => {"Hp" => {"LoginName" => username}}}
      response = rest_post('/redfish/v1/AccountService/Accounts/', body: newAction)
      response_handler(response)
      true
    end

    # Change the password for a user
    # @param [String, Symbol] username
    # @param [String, Symbol] password
    # @raise [RuntimeError] if the request failed
    # @return true
    def change_password(username, password)
      newAction = {"Password" => password}
      userhref = userhref('/redfish/v1/AccountService/Accounts/', username)
      response = rest_patch(userhref, body: newAction)
      response_handler(response)
      true
    end

    # Delete a specific user
    # @param [String, Symbol] username
    # @raise [RuntimeError] if the request failed
    # @return true
    def delete_user(username)
      userhref = userhref('/redfish/v1/AccountService/Accounts/', username)
      response = rest_delete(userhref)
      response_handler(response)
      true
    end
  end
end
