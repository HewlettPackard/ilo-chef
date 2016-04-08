## iLO

### How to use the iLO Cookbook:
 1. Install Chefdk on your Workstation.
 2. Update knife.rb with the Chef Server details.
 3. Download the iLO Cookbook.
 4. Update ilo_info.rb in iLO/libraries/ with the ILO details.
 5. Update your recipe with below examples and start using it.


# Use-cases covered in this provider Cookbook
## A. User Addition/deletion/Changing Password

### 1. User Delete

```ruby
iLO_user 'user delete' do
  username 'test'
  ilo_names ["ILO-02"]
  action :deleteUser
end
```


### 2. User Addition

```ruby
iLO_user 'user create' do
  username 'test'
  password 'password123'
  ilo_names ["ILO-02"]
end
```


### 3. Change Password

```ruby
iLO_user 'user reset password' do
  username 'test'
  password 'password12'
  action :changePassword
  ilo_names ["ILO-02"]
end
```


## B. Power On/Off/Reset

### 1. Power On System

```ruby
iLO_powermgmt 'power on' do
  action :poweron
  ilo_names ["ILO-02"]
end
```


### 2. Power Off System1.

```ruby
iLO_powermgmt 'power off' do
  action :poweron
   ilo_names ["ILO-02"]
end
```


### 3. Power Reset System

```ruby
iLO_powermgmt 'resetsys' do
  action :resetsys
   ilo_names ["ILO-02"]
 end
```

## C: Firmware Upgrade

```ruby
iLO_fw_up 'fw_up' do
  ilo_names ["ILO-02"]
  fw_uri "http://10.254.224.38:8000/ilo4_240.bin"
  action :fw_up
end
```

## D: Mount ISO

```ruby
iLO_virtual_media 'mount iso' do
  ilo_names ['ILO-02']
   iso_uri 'http://10.254.224.38:5000/ubuntu-15.04-desktop-amd64.iso'
   boot_on_next_server_reset false
  action :mount
end
```
