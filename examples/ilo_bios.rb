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


# Managing iLO BIOS settings

# List of iLOs (replace with your own hostnames and credentials):
my_ilos = [
  { host: 'ilo1.example.com', user: 'Admin', password: 'secret123' },
  { host: 'ilo2.example.com', user: 'Admin', password: 'secret456' }
]

# Example: Revert iLO BIOS settings to the base (default) configuration
# If you want to ensure that the BIOS settings are always set to the defaults, you can have Chef
# help you ensure that they never change.
ilo_bios 'revert BIOS settings' do
  ilos my_ilos
  action :revert
end

# Example: Set all iLO BIOS settings
# Note that no action is required for this resource, because the default is :set.
# The settings parameter is the important piece, and it takes a hash of key: value pairs. Only the
# attributes that you specify will be set; the other attributes will be left alone. The most
# difficult part of using this resource is knowing what they settings keys are, and what the type
# of the value is. This example shows what can be set on one specific iLO; your device may support
# different attributes, so don't take this as gospel. You can check your bios settings by running:
# $ ilo-ruby --host ilo1.example.com -u Admin -p secret123 rest get redfish/v1/Systems/1/bios/Settings/`
# (replace the host, user, and password with your own)
ilo_bios 'set all BIOS settings' do
  ilos my_ilos
  settings(
    AcpiRootBridgePxm: 'Enabled',
    AcpiSlit: 'Enabled',
    AdjSecPrefetch: 'Enabled',
    AdminEmail: '',
    AdminName: '',
    AdminOtherInfo: '',
    AdminPassword: nil,
    AdminPhone: '',
    AdvancedMemProtection: 'AdvancedEcc',
    AsrStatus: 'Enabled',
    AsrTimeoutMinutes: '10',
    AssetTagProtection: 'Unlocked',
    AutoPowerOn: 'RestoreLastState',
    BootMode: 'Uefi',
    BootOrderPolicy: 'RetryIndefinitely',
    ChannelInterleaving: 'Enabled',
    CollabPowerControl: 'Enabled',
    ConsistentDevNaming: 'LomsOnly',
    CustomPostMessage: '',
    DaylightSavingsTime: 'Disabled',
    DcuIpPrefetcher: 'Enabled',
    DcuStreamPrefetcher: 'Enabled',
    Description: 'This is the Platform/BIOS Configuration (RBSU) Pending Settings',
    Dhcpv4: 'Enabled',
    DynamicPowerCapping: 'Disabled',
    DynamicPowerResponse: 'Fast',
    EmbNicEnable: 'Enabled',
    EmbSata1Enable: 'Enabled',
    EmbSata2Enable: 'Enabled',
    EmbVideoConnection: 'Auto',
    EmbeddedDiagnostics: 'Enabled',
    EmbeddedDiagsMode: 'Auto',
    EmbeddedSata: 'Ahci',
    EmbeddedSerialPort: 'Com1Irq4',
    EmbeddedUefiShell: 'Enabled',
    EmbeddedUserPartition: 'Disabled',
    EmsConsole: 'Disabled',
    EnergyPerfBias: 'BalancedPerf',
    EraseUserDefaults: 'No',
    ExtendedAmbientTemp: 'Disabled',
    ExtendedMemTest: 'Disabled',
    F11BootMenu: 'Enabled',
    FCScanPolicy: 'CardConfig',
    FanFailPolicy: 'Shutdown',
    FanInstallReq: 'EnableMessaging',
    FlexLom1Enable: 'Enabled',
    HwPrefetcher: 'Enabled',
    IntelDmiLinkFreq: 'Auto',
    IntelNicDmaChannels: 'Enabled',
    IntelPerfMonitoring: 'Disabled',
    IntelProcVtd: 'Enabled',
    IntelQpiFreq: 'Auto',
    IntelQpiLinkEn: 'Auto',
    IntelQpiPowerManagement: 'Enabled',
    IntelligentProvisioning: 'Enabled',
    InternalSDCardSlot: 'Enabled',
    IoNonPostedPrefetching: 'Enabled',
    Ipv4Address: '0.0.0.0',
    Ipv4Gateway: '0.0.0.0',
    Ipv4PrimaryDNS: '0.0.0.0',
    Ipv4SecondaryDNS: '0.0.0.0',
    Ipv4SubnetMask: '0.0.0.0',
    Ipv6Duid: 'Auto',
    MaxMemBusFreqMHz: 'Auto',
    MaxPcieSpeed: 'MaxSupported',
    MemFastTraining: 'Enabled',
    MinProcIdlePkgState: 'C6Retention',
    MinProcIdlePower: 'C6',
    MixedPowerSupplyReporting: 'Enabled',
    # Modified: '2016-07-28T05:17:16+00:00', # Read-Only
    Name: 'BIOS Pending Settings',
    NetworkBootRetry: 'Enabled',
    NicBoot1: 'NetworkBoot',
    NicBoot2: 'Disabled',
    NicBoot3: 'Disabled',
    NicBoot4: 'Disabled',
    NicBoot5: 'NetworkBoot',
    NicBoot6: 'Disabled',
    NicBoot7: 'Disabled',
    NicBoot8: 'Disabled',
    NmiDebugButton: 'Enabled',
    NodeInterleaving: 'Disabled',
    NumaGroupSizeOpt: 'Clustered',
    NvDimmNIntegrityChecking: 'Enabled',
    NvDimmNMemInterleaving: 'Disabled',
    OldAdminPassword: nil,
    OldPowerOnPassword: nil,
    PciBusPadding: 'Enabled',
    PciSlot1Enable: 'Enabled',
    PcieExpressEcrcSupport: 'Disabled',
    PostF1Prompt: 'Delayed20Sec',
    PowerButton: 'Enabled',
    PowerOnDelay: 'None',
    PowerOnLogo: 'Enabled',
    PowerOnPassword: nil,
    PowerProfile: 'Custom',
    PowerRegulator: 'DynamicPowerSavings',
    PreBootNetwork: 'Auto',
    ProcAes: 'Enabled',
    ProcCoreDisable: 0,
    ProcNoExecute: 'Enabled',
    ProcVirtualization: 'Enabled',
    ProcX2Apic: 'Enabled',
    ProductId: '',
    QpiBandwidthOpt: 'Balanced',
    QpiSnoopConfig: 'Standard',
    RedundantPowerSupply: 'BalancedMode',
    RemovableFlashBootSeq: 'ExternalKeysFirst',
    RestoreDefaults: 'No',
    RestoreManufacturingDefaults: 'No',
    RomSelection: 'CurrentRom',
    SataSecureErase: 'Disabled',
    SaveUserDefaults: 'No',
    # SecureBootStatus: 'Disabled', # Read-Only
    SerialConsoleBaudRate: '115200',
    SerialConsoleEmulation: 'Vt100Plus',
    SerialConsolePort: 'Auto',
    SerialNumber: '',
    ServerAssetTag: '',
    ServerName: 'WIN-2HH8P0GMSUS',
    ServerOtherInfo: '',
    ServerPrimaryOs: '',
    ServiceEmail: 'admin@example.com',
    ServiceName: 'iLO Admin',
    ServiceOtherInfo: '',
    ServicePhone: '',
    Slot1NicBoot1: 'NetworkBoot',
    Slot1NicBoot2: 'Disabled',
    Slot1NicBoot3: 'Disabled',
    Slot1NicBoot4: 'Disabled',
    Sriov: 'Enabled',
    ThermalConfig: 'OptimalCooling',
    ThermalShutdown: 'Enabled',
    TimeFormat: 'Utc',
    TimeZone: 'Utc0',
    Tpm2Operation: 'NoAction',
    Tpm2Ppi: 'Disabled',
    Tpm2Visibility: 'Visible',
    TpmBinding: 'Disabled',
    # TpmState: 'PresentEnabled', # Read-Only
    # TpmType: 'Tpm20', # Read-Only
    TpmUefiOpromMeasuring: 'Enabled',
    # Type: 'HpBios.1.2.0', # Read-Only
    UefiOptimizedBoot: 'Enabled',
    UefiPxeBoot: 'Auto',
    UefiShellBootOrder: 'Disabled',
    UefiShellStartup: 'Disabled',
    UefiShellStartupLocation: 'Auto',
    UefiShellStartupUrl: '',
    UrlBootFile: '',
    Usb3Mode: 'Auto',
    UsbBoot: 'Enabled',
    UsbControl: 'UsbEnabled',
    UtilityLang: 'English',
    VirtualInstallDisk: 'Disabled',
    VirtualSerialPort: 'Com2Irq3',
    VlanControl: 'Disabled',
    VlanId: 0,
    VlanPriority: 0,
    WakeOnLan: 'Enabled'
  )
end

# Example: Set a subset of iLO BIOS settings
# Wow. That's one big resource definition! However, you don't have to specify every possible
# attribute in the settings. Only the attributes that you specify will be set; the other
# attributes will be left alone. Here we just define a subset of settings to ensure are set
# accordingly.
ilo_bios 'set a subset of BIOS settings' do
  ilos my_ilos
  settings(
    UefiShellStartup: 'Disabled',
    UefiShellStartupLocation: 'Auto',
    Dhcpv4: 'Enabled',
    Ipv4Address: '0.0.0.0',
    Ipv4Gateway: '0.0.0.0',
    Ipv4PrimaryDNS: '0.0.0.0',
    Ipv4SecondaryDNS: '0.0.0.0',
    ServiceName: 'iLO Admin',
    ServiceEmail: 'admin@example.com'
  )
end
