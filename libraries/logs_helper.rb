module ILO_SDK
  # Contains helper methods for Logs actions
  module Logs_Helper
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

    #def clear_iel_logs(machine)
    #  newAction = {"Action"=> "ClearLog"}
    #  options = {'body' => newAction}
    #  rest_api(:post, '/redfish/v1/Managers/1/LogServices/IEL/', machine, options)
    #end

    #def clear_iml_logs(machine)
    #  newAction = {"Action"=> "ClearLog"}
    #  options = {'body' => newAction}
    #  rest_api(:post, '/redfish/v1/Systems/1/LogServices/IML/', machine, options)
    #end

    #def dump_iel_logs(machine,ilo,severity_level,file,duration)
    #  entries = rest_api(:get, '/redfish/v1/Managers/1/LogServices/IEL/Entries/', machine)["links"]["Member"]
    #  entries.each do |e|
    #    logs = rest_api(:get, e["href"], machine)
    #    severity = logs["Severity"]
    #    message = logs["Message"]
    #    created = logs["Created"]
    #    if !severity_level.nil?
    #      ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if created == severity_level and Time.parse(created) > (Time.now.utc - (duration*3600))
    #    else
    #      ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if Time.parse(created) > (Time.now.utc - (duration*3600))
    #    end
    #    File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
    #  end
    #end

    #def dump_iml_logs(machine, ilo, severity_level,file,duration)
    #  entries = rest_api(:get, '/redfish/v1/Systems/1/LogServices/IML/Entries/', machine)["links"]["Member"]
    #  entries.each do |e|
    #    logs = rest_api(:get, e["href"], machine)
    #    severity = logs["Severity"]
    #    message = logs["Message"]
    #    created = logs["Created"]
    #    if !severity_level.nil?
    #      ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if created == severity_level and Time.parse(created) > (Time.now.utc - (duration*3600))
    #    else
    #      ilo_log_entry = "#{ilo} | #{severity} | #{message} | #{created} \n" if Time.parse(created) > (Time.now.utc - (duration*3600))
    #    end
    #    File.open("#{Chef::Config[:file_cache_path]}/#{file}.txt", 'a+') {|f| f.write(ilo_log_entry) }
    #  end
    #end
    
  end
end
