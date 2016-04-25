# iLO

Enables interraction with HPE iLO APIs.

### Requirements
 - Chef 12+
 - iLO 4

### How to use the iLO Cookbook:
This cookbook is not intended to include any recipes.
Use it by creating a new cookbook and specifying a dependency on this cookbook.

```ruby
# my_cookbook/metadata.rb
...
depends 'iLO'
```

Now you can use the resources this cookbook provides. See below for some examples.


# iLO Authentication
Each of the resources below requires you to pass in the info necessary to connect with the iLO API.
The basic structure accepted by the `ilos` property is an array of hashes:

```ruby
ilos = [
  {
    host: 'ilo1.example.com',  # Required. IP or hostname
    user: 'Administrator',     # Optional. Defaults to 'Administrator'
    password: 'secret123'      # Required
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


# iLO Resources
The following resources are available for usage in your recipes:

### iLO_user

 - **Create User:**

  ```ruby
  iLO_user 'user create' do
    username 'test'
    password 'password123'
    ilos [ilo1, ilo2]
  end
  ```

 - **Delete User:**

  ```ruby
  iLO_user 'user delete' do
    username 'test'
    ilos [ilo1, ilo2]
    action :deleteUser
  end
  ```


 - **Update User Password:**

  ```ruby
  iLO_user 'user set password' do
    username 'test'
    password 'password12'
    ilos [ilo1, ilo2]
    action :changePassword
  end
  ```


### iLO_powermgmt

 - **Power On System:**

  ```ruby
  iLO_powermgmt 'power on' do
    ilos [ilo1, ilo2]
    action :poweron
  end
  ```

 - **Power Off System:**

  ```ruby
  iLO_powermgmt 'power off' do
    ilos [ilo1, ilo2]
    action :poweron
  end
  ```

 - **Reset System:**

  ```ruby
  iLO_powermgmt 'resetsys' do
    ilos [ilo1, ilo2]
    action :resetsys
  end
  ```


### iLO_fw_up

 - **Upgrade a system's firmware:**

  ```ruby
  iLO_fw_up 'fw_up' do
    ilos [ilo1, ilo2]
    fw_uri "http://10.254.224.38:8000/ilo4_240.bin"
    action :fw_up
  end
  ```


### iLO_virtual_media

 - **Mount an ISO image:**

  ```ruby
  iLO_virtual_media 'mount iso' do
    ilos [ilo1, ilo2]
    iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
    boot_on_next_server_reset false
    action :mount
  end
  ```


### iLO_boot_order

 - **Dump Boot Order to a file:**

  ```ruby
  iLO_boot_order 'get boot order' do
    ilos [ilo1, ilo2]
    dump_file "save_me_here"
    action :dump
  end
  ```

  - **Dump Boot Order to data_bag:**

   ```ruby
   iLO_boot_order 'get boot order' do
     ilos [ilo1, ilo2]
     data_bag "my_data_bag"
     action :dump
   end
   ```

 - **Change Boot Order:**

  ```ruby
  iLO_boot_order 'change boot order' do
    ilos [ilo1, ilo2]
    boot_order ["1st", "2nd", "3rd", "4th", "5th", "6th"]
    action :set
  end
  ```

 - **Change Boot Order Temporarily:**

  ```ruby
  iLO_boot_order 'change boot order temporarily' do
    ilos [ilo1, ilo2]
    boot_target "Cd"
    action :set_temporary
  end
  ```

 - **Revert Boot Order to Default:**

  ```ruby
  iLO_boot_order 'revert boot order' do
    ilos [ilo1, ilo2]
    action :revert
  end
  ```


### iLO_indicator_led

 - **Set UID Indicator LED:**

  ```ruby
  iLO_indicator_led 'set led state' do
    ilos [ilo1, ilo2]
    led_state 'Off'
  end
  ```
