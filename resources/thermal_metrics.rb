actions :get

property :ilos, Array, :required => true
property :thermal_metrics_file, String, :required => true
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include ClientHelper

action :get do

  thermal_metrics = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    thermal_metrics = thermal_metrics + client.get_thermal_metrics.to_yaml + "\n"
  end
  file thermal_metrics_file do
    owner owner
    group group
    content thermal_metrics
  end
end
