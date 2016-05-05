actions :get

property :ilos, Array, :required => true
property :power_metrics_file, String, :required => true
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include IloHelper

action :get do
  load_sdk(self)
  power_metrics = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    power_metrics = power_metrics + client.get_power_metrics.to_yaml + "\n"
  end
  file power_metrics_file do
    owner owner
    group group
    content power_metrics
  end
end
