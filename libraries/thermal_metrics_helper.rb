module ILO_SDK
  module Thermal_Metrics_Helper
    # Get the vital thermal metrics
    # @raise [RuntimeError] if the request failed
    # @return [Hash] thermal_metrics
    def get_thermal_metrics
      chassis = rest_get('/redfish/v1/Chassis/')
      chassis_uri = response_handler(chassis)["links"]["Member"][0]["href"]
      thermal_metrics_uri = response_handler(rest_get(chassis_uri))["links"]["ThermalMetrics"]["href"]
      response = rest_get(thermal_metrics_uri)
      temperatures = response_handler(response)["Temperatures"]
      temp_details = []
      temperatures.each do |temp|
        temp_detail = {
          "PhysicalContext" => temp["PhysicalContext"],
          "Name" => temp["Name"],
          "CurrentReading" => temp["ReadingCelsius"],
          "CriticalThreshold" => temp["LowerThresholdCritical"],
          "Health" => temp["Status"]["Health"],
          "State" => temp["Status"]["State"]

        }
        temp_details.push(temp_detail)
      end
        thermal_metrics = {
          @host => temp_details
        }
    end
  end
end
