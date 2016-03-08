#
# Cookbook Name:: iLORestCookbook
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
require 'pry'
#Chef::Resource::Execute.send(:include, RestAPI::Helper)
#To Add user on all the
#
::Chef::Recipe.send(:include, RestAPI::Helper)
::Chef::Recipe.send(:include, ILOINFO)

 # iLOResourceProvider_ilo_user 'user reset password' do
 #   username 'pappu'
 #   password 'password12'
 #   ilo_names ["ILO-02"]
 #   action :changePassword
 # end

 # iLOResourceProvider_ilo_user 'user delete' do
 #   username 'test'
 #   ilo_names :all
 #   action :deleteUser
 # end


 # iLOResourceProvider_ilo_user 'user create' do
 #   username 'pappu1'
 #   password 'password123'
 #   ilo_names ["ILO-02"]
 # end


# iLOResourceProvider_ilo_powermgmt 'power off' do
#   ilo_names :all
#   action :poweroff
# end
#
# iLOResourceProvider_ilo_powermgmt 'power on' do
#   ilo_names :all
#   action :poweron
# end


#  iLOResourceProvider_ilo_powermgmt 'resetsys' do
#    ilo_names :all
#    action :resetsys
#  end

# iLOResourceProvider_ilo_fw_up 'fw_up' do
#   ilo_names ["ILO-02"]
#   fw_uri "http://10.254.224.38:8000/ilo4_240.bin"
#   action :fw_up
# end

# iLOResourceProvider_ilo_license 'fw_up' do
#   ilo_names ["ILO-02"]
#   license_key "333TJ-XN732-5CRYY-RVXYH-KJDJR"
#   action :apply
# end

# iLOResourceProvider_ilo_logs 'clear logs' do
#   ilo_names ["ILO-02"]
#   log_type 'iel'
#   action :clear
# end

# iLOResourceProvider_ilo_logs 'dump iel logs' do
#   ilo_names ["ILO-02"]
#   log_type 'iml'
#   severity_level 'any'
#   duration_in_hours 24
#   filename "logs3"
#   action :dump
# end

# iLOResourceProvider_ilo_uefi 'secure boot' do
#   ilo_names ["ILO-02"]
#   enable true
#   action :secure_boot
# end
#
# iLOResourceProvider_ilo_uefi 'revert bios' do
#   ilo_names ["ILO-02"]
#   action :revert_bios
# end
#
# iLOResourceProvider_ilo_boot_order 'revert bios' do
#   ilo_names ["ILO-02"]
#   action :reset
# end


# iLOResourceProvider_ilo_eth_net_interface 'use NTP servers' do
#   ilo_names ["ILO-02"]
#   value false
#   action :use_ntp
# end
#
#  iLOResourceProvider_ilo_powermgmt 'resetsys' do
#    ilo_names ["ILO-02"]
#    action :resetsys
#  end
#
#  iLOResourceProvider_ilo_time_zone 'set time zone' do
#    ilo_names ["ILO-02"]
#    time_zone_index 272
#    action :set_time_zone
#  end

 iLOResourceProvider_ilo_indicator_led 'set led state' do
   ilo_names ["ILO-02"]
   led_state "Blinking"
   action :set
 end
