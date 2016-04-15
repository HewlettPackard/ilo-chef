actions :dump

property :ilos, Array, :required => true
property :dump_file, String, :required => true
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include ClientHelper

action :dump do
  dumpContent = ""
  ilos.each do |ilo|
    client = build_client(ilo)
    dumpContent = dumpContent + client.get_computer_details.to_yaml + "\n"
  end
  file dump_file do
    owner owner
    group group
    content dumpContent
  end
end
