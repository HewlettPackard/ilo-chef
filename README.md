# iLO Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/ilo.svg)](https://supermarket.chef.io/cookbooks/ilo)

Enables configuration of HPE iLOs via their APIs.

### Requirements

 - Chef 12+
 - iLO 4

### Cookbook Dependencies

 - compat_resource

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
    host: 'ilo1.example.com',      # Required. IP or hostname
    user: 'Administrator',         # Optional. Defaults to 'Administrator'
    password: 'secret123',         # Required
    ssl_enabled: false,            # Optional
    proxy_addr: 'your.proxy.host', # Optional
    proxy_port: 'your.proxy.port'  # Optional
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

The following resources are available for usage in your recipes:

### ilo_bios

 - **Revert to default BIOS base configuration:**

  ```ruby
  ilo_bios 'revert BIOS' do
    ilos [ilo1, ilo2]
    action :revert
  end
  ```

 - **Set BIOS configuration:**

  ```ruby
  ilo_bios 'set BIOS configuration' do
    ilos [ilo1, ilo2]
    uefi_shell_startup 'Enabled'
    uefi_shell_startup_location 'Auto'
    uefi_shell_startup_url 'http://www.uefi.nsh'
    dhcpv4 'Disabled'
    ipv4_address '10.1.1.0'
    ipv4_gateway '10.1.1.11'
    ipv4_primary_dns '10.1.1.1'
    ipv4_secondary_dns '10.1.1.2'
    ipv4_subnet_mask '255.255.255.0'
    url_boot_file 'http://www.urlbootfile.iso'
    service_name 'John Doe'
    service_email 'john.doe@hpe.com'
    action :set # Not necessary, as this is the default
  end
  ```


### ilo_boot_settings

 - **Revert to default Boot base configuration:**

  ```ruby
  ilo_boot_settings 'revert boot' do
    ilos [ilo1, ilo2]
    action :revert
  end
  ```

 - **Set boot configuration:**

  ```ruby
  ilo_boot_settings 'set boot configuration' do
    ilos [ilo1, ilo2]
    boot_order [
      "FD.Virtual.1.1",
      "Generic.USB.1.1",
      "HD.Emb.1.1",
      "HD.Emb.1.2",
      "NIC.LOM.1.1.IPv4",
      "NIC.LOM.1.1.IPv6"
    ]
    boot_target 'None'
    action :set # Not necessary, as this is the default
  end
  ```

 - **Dump the boot configuration to a file:**

  ```ruby
  ilo_boot_settings 'dump boot configuration' do
    ilos [ilo1, ilo2]
    dump_file '/full/path/to/boot_settings.yml'
    owner 'JohnDoe'
    group 'Administrators'
    action :dump
  end
  ```


### ilo_chassis

 - **Dump power metrics and thermal metrics information to a file:**

  ```ruby
  ilo_chassis 'dump power metrics and thermal metrics' do
    ilos [ilo1, ilo2]
    power_metrics_file '/full/path/to/power_metrics.yml'
    thermal_metrics_file '/full/path/to/thermal_metrics.yml'
    owner 'JohnDoe'
    group 'Administrators'
    action :dump
  end
  ```


### ilo_computer_details

 - **Dump computer details to a file and data bag:**

  ```ruby
  ilo_computer_details 'dump computer details' do
    ilos [ilo1, ilo2]
    dump_file '/full/path/to/computer_details.yml'
    data_bag 'computer_details_bag'
    owner 'JohnDoe'
    group 'Administrators'
    action :dump
  end
  ```


### ilo_computer_system

 - **Set computer system information:**

  ```ruby
  ilo_computer_system 'set computer system info' do
    ilos [ilo1, ilo2]
    asset_tag 'HPE001'
    led_state 'Lit'
    action :set
  end
  ```


### ilo_date_time

 - **Set the time zone:**

  ```ruby
  ilo_date_time 'set time zone' do
    ilos [ilo1, ilo2]
    time_zone 'Africa/Abidjan'
    action :set # Not necessary, as this is the default
  end
  ```

 - **Set whether or not to use NTP:**

  ```ruby
  ilo_date_time 'use NTP' do
    ilos [ilo1, ilo2]
    use_ntp true
    action :set_ntp
  end
  ```

 - **Set the NTP servers:**

  ```ruby
  ilo_date_time 'set NTP servers' do
    ilos [ilo1, ilo2]
    ntp_servers [
      "10.168.0.2",
      "10.168.0.3"
    ]
    action :set_ntp_servers
  end
  ```


### ilo_firmware_update

 - **Upgrade firmware:**

  ```ruby
  ilo_firmware_update 'upgrade firmware' do
    ilos [ilo1, ilo2]
    fw_version '2.5'
    fw_uri 'www.firmwareuri.com'
    action :upgrade
  end
  ```


### ilo_https_cert

 - **Generate Certificate Signing Request (CSR):**

  ```ruby
  ilo_https_cert 'generate CSR' do
    ilo ilo1
    country 'USA'
    state 'Texas'
    city 'Houston'
    orgName 'Example Company'
    orgUnit 'Example'
    commonName 'example.com'
    action :generate_csr
  end
  ```

 - **Dump CSR to a file:**

  ```ruby
  ilo_https_cert 'dump CSR to file' do
    ilo ilo1
    file_path '/c/CSR.cert'
    action :get_csr
  end
  ```

 - **Import certificate:**

  ```ruby
  ilo_https_cert 'import certificate' do
    ilo ilo1
    certificate '-----BEGIN CERTIFICATE-----
    SecretCertificateContent
    -----END CERTIFICATE-----'
    action :import
  end
  ```

 - **Import certificate from file:**

  ```ruby
  ilo_https_cert 'import certificate from file' do
    ilo ilo1
    file_path '/c/certificate_file.cert'
    action :import
  end
  ```

 - **Complete HTTPS Certificate Replacement Example**

  ```ruby
  require 'ilo-sdk'

  ilo1 = ILO_SDK::Client.new(
    host: 'ilo1.example.com',
    user: 'Administrator',
    password: 'secret123'
  )

  # Get the current SSL Certificate and check to see if expires within 24 hours
  expiration = ilo1.get_certificate.not_after.to_datetime
  tomorrow = DateTime.now + 1

  valid = expiration > tomorrow
  ilo_https_cert 'generate CSR' do
    ilo ilo1
    country 'USA'
    state 'Texas'
    city 'Houston'
    orgName 'Example Company'
    orgUnit 'Example'
    commonName 'example.com'
    action :generate_csr
    not_if { valid || ilo1.get_csr } # Only generate if the cert is expiring soon and the CSR has not already been generated
  end

  ilo_https_cert 'dump CSR to file' do
    ilo ilo1
    file_path '~/certs/CSR.cert'
    action :get_csr
    not_if { valid || ilo1.get_csr.nil? }
  end

  # Here you'll need to have a step that submits the CSR to a certificate authority
  # (or self-signs it) and gets back the signed certificate. It will look something like:
  # -----BEGIN CERTIFICATE-----
  # lines_of_secret_text
  # -----END CERTIFICATE-----
  # For this example, we're assuming we've read in the content of the certificate to the
  # "cert" variable (as a string).

  ilo_https_cert 'import certificate' do
    ilo ilo1
    certificate cert
    action :import
    not_if { valid || cert.nil? }
  end
  ```


### ilo_log_entry

 - **Dump log entries to a file:**

  ```ruby
  ilo_log_entry 'dump log entries' do
    ilos [ilo1, ilo2]
    log_type 'IEL'
    dump_file 'IEL_logs.txt'
    owner 'JohnDoe'
    group 'Administrators'
    duration 30 # up to hours back from now
    action :dump # Not necessary, as this is the default
  end
  ```

 - **Clear log entries:**

  ```ruby
  ilo_log_entry 'clear log entries' do
    ilos [ilo1, ilo2]
    log_type 'IEL'
    action :clear
  end
  ```


### ilo_manager_network_protocol

 - **Set ilo session timeout:**

  ```ruby
  ilo_manager_network_protocol 'set timeout' do
    ilos [ilo1, ilo2]
    timeout 60 # minutes
    action :set
  end
  ```


### ilo_power

 - **Power on the system:**

  ```ruby
  ilo_power 'power on' do
    ilos [ilo1, ilo2]
    action :poweron # Not necessary, as this is the default
  end
  ```

 - **Power off the system:**

  ```ruby
  ilo_power 'power off' do
    ilos [ilo1, ilo2]
    action :poweroff
  end
  ```

 - **Reset the system:**

  ```ruby
  ilo_power 'reset system' do
    ilos [ilo1, ilo2]
    action :resetsys
  end
  ```

 - **Reset ilo:**

  ```ruby
  ilo_power 'reset ilo' do
    ilos [ilo1, ilo2]
    action :resetilo
  end
  ```


### ilo_secure_boot

 - **Set whether or not to enable UEFI secure boot:**

  ```ruby
  ilo_secure_boot 'enable secure boot' do
    ilos [ilo1, ilo2]
    enable true
    action :set
  end
  ```


### ilo_service_root

 - **Dump schema and registry information to a file:**

  ```ruby
  ilo_service_root 'dump schema and registry' do
    ilos [ilo1, ilo2]
    schema_prefix 'Account'
    schema_file 'schema.txt'
    registry_prefix 'Base'
    registry_file 'registry.txt'
    owner 'JohnDoe'
    group 'Administrators'
    action :dump
  end
  ```


### ilo_snmp_service

 - **Configure SNMP service:**

  ```ruby
  ilo_snmp_service 'set snmp mode and turn alerts on' do
    ilos [ilo1, ilo2]
    snmp_mode 'Agentless'
    snmp_alerts true
    action :configure
  end
  ```


### ilo_user

 - **Create or modify user:**

  ```ruby
  ilo_user 'creater user' do
    ilos [ilo1, ilo2]
    username 'test'
    password 'password123'
    login_priv true
    remote_console_priv false
    user_config_priv true
    virtual_media_priv false
    virtual_power_and_reset_priv true
    ilo_config_priv false
  action :create
  end
  ```

 - **Delete user:**

  ```ruby
  ilo_user 'delete user' do
    ilos [ilo1, ilo2]
    username 'test'
    action :delete
  end
  ```

### ilo_virtual_media

 - **Insert virtual media:**

  ```ruby
  ilo_virtual_media 'insert virtual media' do
    ilos [ilo1, ilo2]
    iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
    action :insert # Not necessary, as this is the default
  end
  ```

 - **Eject virtual media:**

  ```ruby
  ilo_virtual_media 'eject virtual media' do
    ilos [ilo1, ilo2]
    action :eject
  end
  ```


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
