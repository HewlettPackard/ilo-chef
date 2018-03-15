### 1.4.0
 - Fixed bugs in ilo_date_time resource and renamed `use_ntp` property to `use_dhcpv4` (breaking change).
 - Remove dependency on compat_resource and bumped minimum Chef client version to 12.7
 - Added examples

### 1.3.1
 - Fixed bug in ilo_https_cert resource: Accept `ILO_SDK::Client` object for ilo property.
 - Fixed bug in ilo_firmware_update resource: Accept String for fw_version property.
 - Fix other various property restrictions,
 - Fixed bug in ilo_https_cert :import when importing from file.

### 1.3.0
 - Refactored ilo_bios resource to support all settings. (Breaking Change)

### 1.2.0
 - Moved resources into libraries
 - Added ilo_https_cert resource

#### 1.0.1
 - Updated metadata.rb file

## 1.0.0
Initial release
