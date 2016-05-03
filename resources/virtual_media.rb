actions :mount

property :ilos, Array, :required => true
property :iso_uri, String, :required => true, :regex => /^(ht|f)tp:\/\/[A-Za-z0-9]([-.\w]*[A-Za-z0-9])([A-Za-z0-9\-\.\?,'\/\\\+&;%\$#~=_]*)?(.iso)$/
property :boot_on_next_server_reset, [TrueClass,FalseClass], :default => false

include ClientHelper

action :mount do
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_virtual_media
    puts
    puts
    puts cur_val.to_s
    puts
    puts
    cur_val.each do |key, hash|
      unless hash['MediaTypes'].include?('CD') || hash['MediaTypes'].include?('DVD')
        converge_by "Set ilo #{client.host} ISO URI to '#{iso_uri}' and boot on next server rest to '#{boot_on_next_server_reset.to_s}'" do
          client.set_virtual_media(key, iso_uri, boot_on_next_server_reset)
        end
      end
    end
  end
end
