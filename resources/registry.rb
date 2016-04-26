actions :dump

property :ilos, Array, :required => true
property :dump_file, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']
property :registry_prefix, String

include ClientHelper

action :dump do
  raise 'Please specify dump_file or data_bag!' unless dump_file || data_bag
  dumpContent = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    dumpContent[host.to_s] = client.get_registry(registry_prefix).to_yaml
  end
  file dump_file do
    owner owner
    group group
    content dumpContent.to_yaml
  end
end
