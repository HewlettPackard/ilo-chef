actions :dump
default_action :dump

property :ilos, Array, required: true
property :schema_prefix, String
property :registry_prefix, String
property :schema_file, String
property :registry_file, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

action_class do
  include IloHelper
end

action :dump do
  raise 'Please provide a schema_file and/or registry_file!' unless schema_file || registry_file
  raise 'Please provide a schema_prefix' if schema_file && !schema_prefix
  raise 'Please provide a registry_prefix' if registry_file && !registry_prefix
  load_sdk
  schema_content = {}
  registry_content = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    schema_content[host.to_s] = client.get_schema(schema_prefix).to_yaml if schema_file
    registry_content[host.to_s] = client.get_registry(registry_prefix).to_yaml if registry_file
  end
  if schema_file
    file schema_file do
      owner owner
      group group
      content schema_content.to_yaml
    end
  end
  if registry_file
    file registry_file do
      owner owner
      group group
      content registry_content.to_yaml
    end
  end
end
