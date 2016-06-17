actions :dump
default_action :dump

property :ilos, Array, required: true
property :power_metrics_file, String
property :thermal_metrics_file, String
property :owner, [String, Integer]#, default: node['current_user']
property :group, [String, Integer]#, default: node['current_user']

action_class do
  include IloHelper
end

action :dump do
  raise 'Please provide a power_metrics_file and/or thermal_metrics_file!' unless power_metrics_file || thermal_metrics_file
  load_sdk
  power_metrics = ''
  thermal_metrics = ''
  ilos.each do |ilo|
    client = build_client(ilo)
    power_metrics = power_metrics + client.get_power_metrics.to_yaml + "\n" if power_metrics_file
    thermal_metrics = thermal_metrics + client.get_thermal_metrics.to_yaml + "\n" if thermal_metrics_file
  end
  if power_metrics_file
    file power_metrics_file do
      owner owner
      group group
      content power_metrics
    end
  end
  if thermal_metrics_file
    file thermal_metrics_file do
      owner owner
      group group
      content thermal_metrics
    end
  end
end
