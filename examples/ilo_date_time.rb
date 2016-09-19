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


# Managing iLO date & time settings

# List of iLOs (replace with your own hostnames and credentials):
my_ilos = [
  { host: 'ilo1.example.com', user: 'Admin', password: 'secret123' },
  { host: 'ilo2.example.com', user: 'Admin', password: 'secret456' }
]

# Example: Set the time zone and NTP servers
# Note that we don't need to specify the action, because it will use the :set action by default. Also,
# since we want to set the NTP servers and time zone, we need to set the :use_dhcpv4 property to false
# (this is a restriction in the iLO API). You can find the available time zones by looking on the iLO
# UI (Network > iLO Dedicated Network Port > SNTP) or by running:
#   $ ilo-ruby --host ilo1.example.com -u Admin -p secret123 rest get redfish/v1/Managers/1/DateTime/
ilo_date_time 'set time zone and NTP servers' do
  ilos my_ilos
  use_dhcpv4 false # Don't use the DHCPv4-supplied time settings
  ntp_servers ['10.168.0.2', '10.168.0.3']
  time_zone 'US/Mountain'
end

# Example: Set time by DHCP
# Again, we don't need to specify the action because it will use the :set action by default.
# Here we want to use the DHCP-supplied time settings, so we set the :use_dhcpv4 property to true.
# Since we do this, we cannot set the time zone or NTP servers; DHCP will provide these for us.
ilo_date_time 'set time by DHCP' do
  ilos my_ilos
  use_dhcpv4 true # Use the DHCPv4-supplied time settings
end
