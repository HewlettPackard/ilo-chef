actions :dump, :set, :set_temporary, :revert

property :ilos, Array, :required => true
property :boot_order_file, String
property :boot_order, Array
property :boot_target, String

include ClientHelper

# TODO: append files using same method as in computer_details
action :dump do
  ilos.each do |ilo|
    client = build_client(ilo)
    dumpContent = client.get_all
  end
end

action :set do

end

action :set_temporary do

end

action :revert do

end
