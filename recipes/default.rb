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

 iLOResourceProvider_ilo_user 'user reset password' do
   username 'pappu'
   password 'password12'
   ilo_names ["ILO-02"]
   action :changePassword
 end

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



#ilono.each do |ilo, machine|
# iLOResourceProvider_ilo_powermgmt 'power on' do
#   machine machine
#   action :poweron
# end
#end

#ilono.each do |ilo, machine|
# iLOResourceProvider_ilo_powermgmt 'power off' do
#   machine machine
#   action :poweron
# end
#end

ilono.each do |ilo, machine|
 iLOResourceProvider_ilo_powermgmt 'resetsys' do
   machine machine
   action :poweron
 end
end
