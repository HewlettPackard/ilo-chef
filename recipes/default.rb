#
# Cookbook Name:: iLORestCookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
#Chef::Resource::Execute.send(:include, RestAPI::Helper)
#To Add user on all the
#

 # iLO_user 'user reset password' do
 #   username 'pappu'
 #   password 'password12'
 #   ilo_names ["ILO-02"]
 #   action :changePassword
 # end

 # iLO_user 'user delete' do
 #   username 'test'
 #   ilo_names :all
 #   action :deleteUser
 # end


 # iLO_user 'user create' do
 #   username 'ram'
 #   password 'password123'
 #   ilo_names ["ILO-02"]
 # end


# iLO_powermgmt 'power off' do
#   ilo_names :all
#   action :poweroff
# end
#
# iLO_powermgmt 'power on' do
#   ilo_names :all
#   action :poweron
# end


#  iLO_powermgmt 'resetsys' do
#    ilo_names :all
#    action :resetsys
#  end

# iLO_fw_up 'fw_up' do
#   ilo_names ["ILO-02"]
#   fw_uri "http://10.254.224.38:8000/ilo4_240.bin"
#   action :fw_up
# end

# iLO_license 'apply license' do
#   ilo_names ["ILO-01"]
#   license_key "333TJ-XN732-5CRYY-RVXYH-KJDJR"
#   action :apply
# end

# iLO_logs 'clear logs' do
#   ilo_names ["ILO-02"]
#   log_type 'iel'
#   action :clear
# end

# iLO_logs 'dump iel logs' do
#   ilo_names ["ILO-02"]
#   log_type 'iml'
#   duration_in_hours 24
#   dump_file "iml_logs"
#   action :dump
# end

# iLO_uefi 'secure boot' do
#   ilo_names ["ILO-02"]
#   enable true
#   action :secure_boot
# end
#
# iLO_uefi 'revert bios' do
#   ilo_names ["ILO-02"]
#   action :revert_bios
# end
#
# iLO_boot_order 'revert boot order' do
#   ilo_names ["ILO-02"]
#   action :reset
# end
#
#  iLO_powermgmt 'resetsys' do
#    ilo_names ["ILO-02"]
#    action :resetsys
#  end
iLO_boot_order 'revert boot order' do
  ilo_names ["ILO-02"]
  action :revert
end

# iLO_time_zone 'use NTP servers' do
#   ilo_names ["ILO-02"]
#   value false
#   action :use_ntp
# end
#

 # iLO_time_zone 'set time zone' do
 #   ilo_names ["ILO-02"]
 #   time_zone "Asia/Kolkata"
 #   action :set_time_zone
 # end
 #
  # iLO_powermgmt 'resetilo' do
  #   ilo_names ["ILO-02"]
  #   action :resetilo
  # end

 # iLO_indicator_led 'set led state' do
 #   ilo_names ["ILO-02"]
 #   led_state "Off"
 #   action :set
 # end

 # iLO_computer_details 'dump computer details' do
 #   ilo_names :all
 #   dump_file 'comp_details1'
 #   action :dump
 # end

 # iLO_virtual_media 'mount iso' do
 #   ilo_names ['ILO-02']
 #   iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
 #   boot_on_next_server_reset false
 #   action :mount
 # end


 # iLO_asset_tag 'set asset tag' do
 #   ilo_name 'ILO-02'
 #   asset_tag 'HP001'
 #   action :set
 # end

 # iLO_snmp 'configure snmp' do
 #   ilo_names ['ILO-01']
 #   snmp_mode 'Agentless'
 #   snmp_alerts false
 #   action :configure
 # end

 # iLO_registry 'get registry' do
 #   ilo_name 'ILO-01'
 #   registry_prefix 'iLO'
 #   registry_file 'registry'
 #   action :get_registry
 # end


 # iLO_schema 'get schema' do
 #   ilo_name 'ILO-01'
 #   schema_prefix 'ComputerSystem'
 #   schema_file 'schema'
 #   action :get_schema
 # end

 # iLO_boot_order 'get  boot order' do
 #   ilo_names ['ILO-01', 'ILO-02', 'ILO-03']
 #   boot_order_file 'boot_order_1'
 #   action :get
 # end

 # iLO_boot_order 'change to new boot order' do
 #   ilo_name 'ILO-01'
 #   new_boot_order ["HD.Emb.5.1", "Unknown.Unknown.1", "Unknown.Unknown.2", "Generic.USB.1.1", "NIC.LOM.1.1.IPv6", "NIC.LOM.1.1.IPv4", "NIC.Slot.1.1.IPv6", "NIC.Slot.1.1.IPv4", "NIC.FlexLOM.1.1.IPv4", "NIC.FlexLOM.1.1.IPv6", "CD.Emb.1.1", "HD.Emb.5.2"]
 #   action :change
 # end
 #
  # iLO_powermgmt 'resetsys' do
  #   ilo_names ['ILO-01']
  #   action :resetsys
  # end

 # iLO_boot_order 'change temporary boot order' do
 #   ilo_names ['ILO-01']
 #   boot_target 'Hdd'
 #   action :temporary_change
 # end

 # iLO_bios 'get bios resource' do
 #   ilo_names ['ILO-01']
 #   action :get_bios
 # end

 # iLO_time_zone 'set time zone' do
 #   ilo_names ["ILO-01"]
 #   ntp_servers ['192.168.0.1', '192.168.0.2']
 #   action :set_ntp_servers
 # end
