# iLO Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ilo.svg)](https://supermarket.chef.io/cookbooks/ilo)
[![Travis Build Status](https://travis-ci.org/HewlettPackard/ilo-chef.svg?branch=master)](https://travis-ci.org/HewlettPackard/ilo-chef)
[![Chef Build Status](https://jenkins-01.eastus.cloudapp.azure.com/job/ilo-cookbook/badge/icon)](https://jenkins-01.eastus.cloudapp.azure.com/job/ilo-cookbook/)

Enables configuration of HPE iLOs via their APIs.

### Requirements

- Chef 12.7+
- iLO 4

### Cookbook Dependencies

- none

### How to use the iLO Cookbook:

This cookbook is not intended to include any recipes.
Use it by specifying a dependency on this cookbook in your own cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'ilo'
```

Now you can use the resources this cookbook provides. See below for some examples.


## iLO Authentication

Each of the resources below requires you to pass in the info necessary to connect with the iLO API.
The basic structure accepted by the `ilos` property is an array of hashes (or `ILO_SDK::Client` objects):

```ruby
ilos = [
  {
    host: 'ilo1.example.com',  # Required. IP or hostname
    user: 'Administrator',     # Optional. Defaults to 'Administrator'
    password: 'secret123',     # Required
    ssl_enabled: false         # Optional
  },
  {
    host: '10.0.0.3',
    user: 'User2',
    password: 'secret456'
  }
]
```

This array can be built using a variety of different sources, including [encrypted] databags, attributes, or read from json or yaml files.
For example:

```ruby
# Set directly in recipe:
ilo_list1 = []
ilo_list1.push { host: 'ilo1.example.com', user: 'Administrator', password: 'secret123' }

# Read from data_bag:
ilo_list2 = data_bag_item('ilo_secrets', 'data_center_1')

# Load from yaml file:
ilo_list3 = YAML.load_file('/root/ilo_secrets.yml')
```


## iLO Resources

The following resources are available for usage in your recipes.
We give examples to show how to use each resource, but there are much more detailed examples in the [examples](examples) directory.
You may also find the [recipes in the cookbook used for testing](spec/fixtures/cookbooks/ilo_test/recipes) helpful as examples.

### ilo_bios

 - ####Set BIOS configuration:

  ```ruby
  ilo_bios 'set BIOS configuration' do
    ilos [ilo1, ilo2]
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
      # NOTE: This is just an example; you can set as many or as few settings as you want.
      # (And there's a whole lot more you can set. See the API docs for the complete list.)
    )
    action :set # Not necessary, as this is the default
  end
  ```

 - ####Revert to default BIOS base configuration:

  ```ruby
  ilo_bios 'revert BIOS' do
    ilos [ilo1, ilo2]
    action :revert
  end
  ```


### ilo_boot_settings

 - ####Set boot configuration:

  ```ruby
  ilo_boot_settings 'set boot configuration' do
    ilos [ilo1, ilo2]
    boot_order [       # Optional
      "FD.Virtual.1.1",
      "Generic.USB.1.1",
      "HD.Emb.1.1",
      "HD.Emb.1.2",
      "NIC.LOM.1.1.IPv4",
      "NIC.LOM.1.1.IPv6"
    ]
    boot_target 'None' # Optional
    action :set        # Not necessary, as this is the default
  end
  ```

 - ####Revert to default boot configuration:

  ```ruby
  ilo_boot_settings 'revert boot configuration' do
    ilos [ilo1, ilo2]
    action :revert
  end
  ```

 - ####Dump the boot configuration to a file:

  ```ruby
  ilo_boot_settings 'dump boot configuration' do
    ilos [ilo1, ilo2]
    dump_file '/full/path/to/boot_settings.yml'
    owner 'JohnDoe'        # Optional: Owner of the file. Defaults to the current user
    group 'Administrators' # Optional: Group ownership for the file. Defaults to the current user
    action :dump
  end
  ```


### ilo_chassis

 - ####Dump power metrics and thermal metrics information to a file:

  ```ruby
  ilo_chassis 'dump power metrics and thermal metrics' do
    ilos [ilo1, ilo2]
    power_metrics_file '/full/path/to/power_metrics.yml'
    thermal_metrics_file '/full/path/to/thermal_metrics.yml'
    owner 'JohnDoe'        # Optional: Owner of the file. Defaults to the current user
    group 'Administrators' # Optional: Owner of the file. Defaults to the current user
    action :dump           # Not necessary, as this is the default
  end
  ```


### ilo_computer_details

 - ####Dump computer details to a file and data bag:

  ```ruby
  ilo_computer_details 'dump computer details' do
    ilos [ilo1, ilo2]
    dump_file '/full/path/to/computer_details.yml'
    data_bag 'computer_details_bag'
    owner 'JohnDoe'        # Optional: Owner of the file. Defaults to the current user
    group 'Administrators' # Optional: Owner of the file. Defaults to the current user
    action :dump           # Not necessary, as this is the default
  end
  ```


### ilo_computer_system

 - ####Set computer system information:

  ```ruby
  ilo_computer_system 'set computer system info' do
    ilos [ilo1, ilo2]
    asset_tag 'HPE001' # Optional
    led_state 'Lit'    # Optional: 'Lit' or 'Off'
    action :set        # Not necessary, as this is the default
  end
  ```


### ilo_date_time

 - ####Set the time zone and NTP settings:

  ```ruby
  ilo_date_time 'set time zone' do
    ilos [ilo1, ilo2]
    use_dhcpv4 false           # Optional. Set to true to use the DHCPv4-supplied time settings
    time_zone 'Africa/Abidjan' # Optional. To use this, you must set :use_dhcpv4 to false
    ntp_servers [              # Optional. To use this, you must set :use_dhcpv4 to false
      "10.168.0.2",
      "10.168.0.3"
    ]
    action :set                # Not necessary, as this is the default
  end
  ```


### ilo_firmware_update

 - ####Upgrade firmware:

  ```ruby
  ilo_firmware_update 'upgrade firmware' do
    ilos [ilo1, ilo2]
    fw_version '2.51'
    fw_uri 'www.firmware.domain.com/2.51'
    action :upgrade # Not necessary, as this is the default
  end
  ```


### ilo_https_cert

Note that this resource requires an `ilo` property (Hash or ILO_SDK::Client) instead of an `ilos` property (Array).
You'll need separate ilo_https_cert resources for each iLO you'd like to perform a task on.

 - ####Generate Certificate Signing Request (CSR):

  ```ruby
  ilo_https_cert 'generate CSR' do
    ilo ilo1
    country 'US'
    state 'Texas'
    city 'Houston'
    orgName 'Example Company'
    orgUnit 'Example'
    commonName 'example.com'
    action :generate_csr
  end
  ```

 - ####Dump CSR to a file:

  ```ruby
  ilo_https_cert 'dump CSR to file' do
    ilo ilo1
    file_path '/full/path/to/CSR.cert'
    action :dump_csr
  end
  ```

 - ####Import certificate:

  ```ruby
  ilo_https_cert 'import certificate' do
    ilo ilo1
    certificate '-----BEGIN CERTIFICATE-----...'
    action :import # Not necessary, as this is the default
  end
  ```

 - ####Import certificate from file:

  ```ruby
  ilo_https_cert 'import certificate from file' do
    ilo ilo1
    file_path '/full/path/to/certificate_file.cert'
    action :import # Not necessary, as this is the default
  end
  ```


### ilo_log_entry

 - ####Dump log entries to a file:

  ```ruby
  ilo_log_entry 'dump log entries' do
    ilos [ilo1, ilo2]
    dump_file '/full/path/to/IEL_logs.txt'
    log_type 'IEL'         # 'IEL' or 'IML
    owner 'JohnDoe'        # Optional: Owner of the dump file. Defaults to the current user
    group 'Administrators' # Optional: Owner of the dump file. Defaults to the current user
    duration 30            # Optional: Number of hours ago to begin collection at (until now)
    severity_level 'OK'    # Optional: Exclude this property to get all severities
    action :dump           # Not necessary, as this is the default
  end
  ```

 - ####Clear log entries:

  ```ruby
  ilo_log_entry 'clear log entries' do
    ilos [ilo1, ilo2]
    log_type 'IEL'
    action :clear
  end
  ```


### ilo_manager_network_protocol

 - ####Set ilo session timeout:

  ```ruby
  ilo_manager_network_protocol 'set timeout' do
    ilos [ilo1, ilo2]
    timeout 60  # Minutes
    action :set # Not necessary, as this is the default
  end
  ```


### ilo_power

 - ####Power on the system:

  ```ruby
  ilo_power 'power on' do
    ilos [ilo1, ilo2]
    action :poweron # Not necessary, as this is the default
  end
  ```

 - ####Power off the system:

  ```ruby
  ilo_power 'power off' do
    ilos [ilo1, ilo2]
    action :poweroff
  end
  ```

 - ####Reset/Restart the system:

  ```ruby
  ilo_power 'reset system' do
    ilos [ilo1, ilo2]
    action :resetsys
  end
  ```

 - ####Reset/Restart the iLO:

  ```ruby
  ilo_power 'reset ilo' do
    ilos [ilo1, ilo2]
    action :resetilo
  end
  ```


### ilo_secure_boot

 - ####Set whether or not to enable UEFI secure boot:

  ```ruby
  ilo_secure_boot 'enable secure boot' do
    ilos [ilo1, ilo2]
    enable true # Optional: Defaults to false
    action :set # Not necessary, as this is the default
  end
  ```


### ilo_service_root

 - ####Dump schema and registry information to a file:

  ```ruby
  ilo_service_root 'dump schema and registry' do
    ilos [ilo1, ilo2]
    schema_prefix 'Account'
    schema_file '/full/path/to/schema.txt'
    registry_prefix 'Base'
    registry_file '/full/path/to/registry.txt'
    owner 'JohnDoe'        # Optional: Owner of the dump file(s). Defaults to the current user
    group 'Administrators' # Optional: Owner of the dump file(s). Defaults to the current user
    action :dump           # Not necessary, as this is the default
  end
  
  # Note: You must set the :schema_file or :registry_file property, but are not required to set both
  ```


### ilo_snmp_service

 - ####Configure SNMP service:

  ```ruby
  ilo_snmp_service 'set snmp mode and turn alerts on' do
    ilos [ilo1, ilo2]
    snmp_mode 'Agentless' # Optional: Defaults to 'Agentless'
    snmp_alerts true      # Optional: Defaults to  false
    action :configure     # Not necessary, as this is the default
  end
  ```


### ilo_user

 - ####Create or modify user:

  ```ruby
  ilo_user 'create user' do
    ilos [ilo1, ilo2]
    username 'test'                   # Defaults to the resource's name attribute
    password 'password123'            # Optional for updates, but needed to create
    login_priv true                   # Optional
    remote_console_priv false         # Optional
    user_config_priv true             # Optional
    virtual_media_priv false          # Optional
    virtual_power_and_reset_priv true # Optional
    ilo_config_priv false             # Optional
    action :create                    # Not necessary, as this is the default
  end
  ```

 - ####Delete user:

  ```ruby
  ilo_user 'delete user' do
    ilos [ilo1, ilo2]
    username 'test'
    action :delete
  end
  ```


### ilo_virtual_media

 - ####Insert virtual media:

  ```ruby
  ilo_virtual_media 'insert virtual media' do
    ilos [ilo1, ilo2]
    iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
    action :insert # Not necessary, as this is the default
  end
  ```

 - ####Eject virtual media:

  ```ruby
  ilo_virtual_media 'eject virtual media' do
    ilos [ilo1, ilo2]
    action :eject
  end
  ```


## Examples

See the [examples](examples) directory for examples with more detailed descriptions of using these resources.
It may also be helpful to take a look at [recipes in the cookbook used for testing](spec/fixtures/cookbooks/ilo_test/recipes).


## Contributing & Feature Requests

**Contributing:** Please see [CONTRIBUTING.md](CONTRIBUTING.md) for more info.

**Feature Requests:** If you have a need that is not met by the current implementation, please let us know (via a new issue).
This feedback is crucial for us to deliver a useful product. Do not assume we have already thought of everything, because we assure you that is not the case.

### License

This project is licensed under the Apache 2.0 license. Please see [LICENSE](LICENSE) for more info.

### Testing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for more info.

## Authors

 - Anirudh Gupta - [@Anirudh-Gupta](https://github.com/Anirudh-Gupta)
 - Bik Bajwa - [@bikbajwa](https://github.com/bikbajwa)
 - Jared Smartt - [@jsmartt](https://github.com/jsmartt)
 - Vivek Bhatia - [@vivekbhatia14] (https://github.com/vivekbhatia14)
