ilo =
  {
    host: 'ilo.example.com',
    user: 'Admin',
    password: 'secret123'
  }

ilo_computer_system 'set asset tag and indicator led' do
  ilos [ilo]
  asset_tag 'HP001'
  led_state 'Off'
  action :set
end
