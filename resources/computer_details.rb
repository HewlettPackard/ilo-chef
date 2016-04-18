actions :dump

property :ilos, Array, :required => true
property :dump_file, String
property :data_bag, String
property :owner, [String, Integer], default: node['current_user']
property :group, [String, Integer], default: node['current_user']

include ClientHelper

action :dump do
  raise 'Please specify dump_file or data_bag!' unless dump_file || data_bag
  dumpContent = {}
  ilos.each do |ilo|
    client = build_client(ilo)
    host = ilo[:host] || ilo['host']
    dumpContent[host.to_s] = client.get_computer_details
  end
  if dump_file
    file dump_file do
      owner owner
      group group
      content dumpContent.to_yaml
    end
  end
  if data_bag
    unless Chef::DataBag.list.key?(data_bag)
      new_data_bag = Chef::DataBag.new
      new_data_bag.name(data_bag)
      new_data_bag.save
    end
    dumpContent.each do |host, data|
      new_data = {'id' => host}.merge(data)
      begin
        item = data_bag_item(data_bag, host)
      rescue
        item = Chef::DataBagItem.new
        item.data_bag(data_bag)
      end
      item.raw_data = new_data
      item.save
    end
  end
end
