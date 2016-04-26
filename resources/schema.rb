actions  :dump

property :ilos, Array, :required => true
property :schema_prefix, String
property :dump_file, String, :required => true
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include ClientHelper

action :dump do
  dumpContent = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    dumpContent[host.to_s] = client.get_schema(schema_prefix).to_yaml
  end
  file dump_file do
    owner owner
    group group
    content dumpContent.to_yaml
  end
end
