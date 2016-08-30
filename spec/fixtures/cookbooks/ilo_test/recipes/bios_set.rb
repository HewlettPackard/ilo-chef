# Cookbook Name:: ilo_test
# Recipe:: bios_set
#
# (c) Copyright 2016 Hewlett Packard Enterprise Development LP
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#

ilo_bios 'set bios' do
  ilos node['ilo_test']['ilos']
  settings(
    UefiShellStartup: 'Enabled',
    UefiShellStartupLocation: 'Auto',
    UefiShellStartupUrl: 'http://www.uefi.nsh',
    Dhcpv4: 'Enabled',
    Ipv4Address: '10.1.1.0',
    Ipv4Gateway: '10.1.1.11',
    Ipv4PrimaryDNS: '10.1.1.1',
    Ipv4SecondaryDNS: '10.1.1.2',
    Ipv4SubnetMask: '255.255.255.0',
    UrlBootFile: 'http://www.urlbootfile.iso',
    ServiceName: 'iLO Admin',
    ServiceEmail: 'admin@domain.com'
  )
end
