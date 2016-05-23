actions :set, :use_ntp, :set_ntp_servers

property :ilos, Array, :required => true
property :time_zone, String
property :ntp_servers, Array
property :value, [TrueClass, FalseClass]

action_class do
  include IloHelper
end

action :set do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_time_zone
    next if cur_val == time_zone
    converge_by "Set ilo #{client.host} time zone from '#{cur_val.to_s}' to '#{time_zone.to_s}'" do
      client.set_time_zone(time_zone)
    end
  end
end

action :set_ntp do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_ntp
    next if cur_val == value
    converge_by "Set ilo #{client.host} NTP use to '#{value.to_s}'" do
      client.set_ntp(value)
    end
  end
end

action :set_ntp_servers do
  load_sdk
  ilos.each do |ilo|
    client = build_client(ilo)
    cur_val = client.get_ntp_servers
    next if cur_val == ntp_servers
    converge_by "Set ilo #{client.host} NTP Servers from '#{cur_val.to_s}' to '#{ntp_servers.to_s}'" do
      client.set_ntp_servers(ntp_servers)
    end
  end
end
