ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_boot_settings 'set boot settings' do
  ilos [ilo]
  boot_order [
    'FD.Virtual.1.1',
    'Generic.USB.1.1',
    'HD.Emb.1.1',
    'HD.Emb.1.2',
    'NIC.LOM.1.1.IPv4',
    'NIC.LOM.1.1.IPv6'
  ]
  boot_target 'None'
  action :set
end
