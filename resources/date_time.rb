actions :set

property :ilos, Array, :required => true
property :time_zone, String
property :ntp_servers, Array
property :use_ntp, [TrueClass, FalseClass], :required => true

action_class do
  include IloHelper
end

action :set do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    if time_zone
      cur_val = client.get_time_zone
      next if cur_val == time_zone
      converge_by "Set ilo #{client.host} time zone from '#{cur_val.to_s}' to '#{time_zone.to_s}'" do
        client.set_time_zone(time_zone)
      end
    end
    if ntp_servers
      cur_val = client.get_ntp
      next if cur_val == use_ntp
      converge_by "Set ilo #{client.host} NTP use from '#{cur_val.to_s}' to '#{use_ntp.to_s}'" do
        client.set_ntp(use_ntp)
      end
    end
    if use_ntp
      cur_val = client.get_ntp_servers
      next if cur_val == ntp_servers
      converge_by "Set ilo #{client.host} NTP Servers from '#{cur_val.to_s}' to '#{ntp_servers.to_s}'" do
        client.set_ntp_servers(ntp_servers)
      end
    end
  end
end
