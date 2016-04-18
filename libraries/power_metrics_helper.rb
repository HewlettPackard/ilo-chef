module ILO_SDK
  module Power_Metrics_Helper
    # Get the vital power metrics
    # @raise [RuntimeError] if the request failed
    # @return [Hash] power_metrics

    def get_power_metrics
      chassis = rest_get('/redfish/v1/Chassis/')
      chassis_uri = response_handler(chassis)["links"]["Member"][0]["href"]
      power_metrics_uri = response_handler(rest_get(chassis_uri))["links"]["PowerMetrics"]["href"]
      response = rest_get(power_metrics_uri)
      metrics = response_handler(response)
      binding.pry
      power_supplies = []
      metrics["PowerSupplies"].each do |ps|
        power_supply = {
          "LineInputVoltage" => ps["LineInputVoltage"],
          "LineInputVoltageType" => ps["LineInputVoltageType"],
          "PowerCapacityWatts" => ps["PowerCapacityWatts"],
          "PowerSupplyType" => ps["PowerSupplyType"],
          "Health" => ps["Status"]["Health"],
          "State" => ps["Status"]["State"]
        }
        power_supplies.push(power_supply)
      end
      power_metrics = {
        @host => {
          "PowerCapacityWatts" => metrics["PowerCapacityWatts"],
          "PowerConsumedWatts" => metrics["PowerConsumedWatts"],
          "PowerSupplies" => power_supplies}
        }
      end
    end
  end
