module ILO_SDK
  # Contains helper methods for Logs actions
  module Logs_Helper
    # Clear the specified logs
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return true
    def clear_logs(log_type)
      newAction = {"Action" => "ClearLog"}
      response = rest_post("/redfish/v1/Managers/1/LogServices/#{log_type}/", body: newAction)
      response_handler(response)
      true
    end

    # Check to see if the logs are empty
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return true or false
    def logs_empty?(log_type)
      response = rest_get("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
      response_handler(response)['Items'].empty?
    end

    # Get the specified logs
    # @param [String, Symbol] severity_level
    # @param [String, Symbol] duration
    # @param [String, Symbol] log_type
    # @raise [RuntimeError] if the request failed
    # @return log_entries
    def get_logs(severity_level, duration, log_type)
      response = rest_get("/redfish/v1/Managers/1/LogServices/#{log_type}/Entries/")
      entries = response_handler(response)['Items']
      log_entries = []
      entries.each do |e|
        if !severity_level.nil?
          log_entries.push("#{e['Severity']} | #{e['Message']} | #{e['Created']}") if e['Severity'] == severity_level and Time.parse(e['Created']) > (Time.now.utc - (duration*3600))
        else
          log_entries.push("#{e['Severity']} | #{e['Message']} | #{e['Created']}") if Time.parse(e['Created']) > (Time.now.utc - (duration*3600))
        end
      end
      return log_entries
    end
  end
end
